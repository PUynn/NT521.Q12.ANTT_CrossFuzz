pragma solidity ^0.4.26;

contract Sink {
    uint256 public received;
    bool public reject;

    event Received(address from, uint256 value);

    function setReject(bool b) public {
        reject = b;
    }

    function() public payable {
        if (reject) {
            revert();
        }
        received += msg.value;
        emit Received(msg.sender, msg.value);
    }
}

contract PyramidCore {
    struct Participant {
        address addr;
        uint256 payout;
    }

    Participant[] public participants;
    uint256 public payoutIdx;
    uint256 public balance;
    uint256 public feePercent = 10;

    address public sink;

    event Joined(address who, uint256 value);
    event Paid(address to, uint256 value);
    event Leaked(address to, uint256 value);

    constructor(address _sink) public {
        sink = _sink;
    }

    function() public payable {
        join();
    }

    function join() public payable {
        if (msg.value < 1 ether) {
            leakFee(msg.value);
            return;
        }

        uint256 fee = msg.value * feePercent / 100;
        uint256 net = msg.value - fee;

        participants.push(Participant(msg.sender, net * 2));
        balance += net;

        leakFee(fee);

        payOut();
        emit Joined(msg.sender, msg.value);
    }

    function payOut() internal {
        while (payoutIdx < participants.length &&
               balance >= participants[payoutIdx].payout) {

            Participant storage p = participants[payoutIdx];

            // Vulnerability: unchecked send
            p.addr.send(p.payout);

            balance -= p.payout;
            emit Paid(p.addr, p.payout);
            payoutIdx++;
        }
    }

    function leakFee(uint256 v) internal {
        if (v == 0) return;

        // Cross-contract ether leak
        sink.call.value(v)("");
        emit Leaked(sink, v);
    }

    function participantCount() public view returns (uint256) {
        return participants.length;
    }
}

contract Driver {
    PyramidCore public core;

    constructor(address _core) public {
        core = PyramidCore(_core);
    }

    function join() public payable {
        core.join.value(msg.value)();
    }

    function participantCount() public view returns (uint256) {
        return core.participantCount();
    }
}

contract Deployer {
    function deploy() public payable
        returns (address sinkAddr, address coreAddr, address driverAddr)
    {
        Sink sink = new Sink();
        PyramidCore core = new PyramidCore(address(sink));
        Driver driver = new Driver(address(core));

        if (msg.value > 0) {
            address(core).transfer(msg.value);
        }

        return (address(sink), address(core), address(driver));
    }

    function() public payable {}
}

