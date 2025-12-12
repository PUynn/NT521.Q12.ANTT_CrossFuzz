pragma solidity ^0.4.26;

contract Winner {
    bool public reject;
    uint256 public received;

    event Received(address from, uint256 value);

    function setReject(bool r) public {
        reject = r;
    }

    function() public payable {
        if (reject) {
            revert();
        }
        received += msg.value;
        emit Received(msg.sender, msg.value);
    }
}

contract Collector {
    uint256 public received;

    event Collected(address from, uint256 value);

    function() public payable {
        received += msg.value;
        emit Collected(msg.sender, msg.value);
    }
}

contract LottoCore {
    bool public payedOut;
    address public winner;
    uint256 public winAmount;

    event SentToWinner(address w, uint256 v);
    event LeftoverWithdrawn(address to, uint256 v);

    constructor(address _winner, uint256 _amount) public payable {
        winner = _winner;
        winAmount = _amount;
        payedOut = false;
    }

    function() public payable {}

    function sendToWinner() public {
        require(!payedOut);

        // unchecked low-level call
        winner.send(winAmount);

        payedOut = true;
        emit SentToWinner(winner, winAmount);
    }

    function withdrawLeftOver(address collector) public {
        require(payedOut);

        // unchecked low-level call
        collector.send(address(this).balance);

        emit LeftoverWithdrawn(collector, address(this).balance);
    }
}

contract Driver {
    LottoCore public lotto;

    constructor(address _lotto) public {
        lotto = LottoCore(_lotto);
    }

    function sendToWinner() public {
        lotto.sendToWinner();
    }

    function withdraw(address collector) public {
        lotto.withdrawLeftOver(collector);
    }
}

contract Deployer {
    function deploy(address winner, uint256 amount)
        public
        payable
        returns (address winnerAddr, address lottoAddr, address driverAddr)
    {
        Winner w = Winner(winner);
        LottoCore lotto = (new LottoCore).value(msg.value)(winner, amount);
        Driver driver = new Driver(address(lotto));
        return (address(w), address(lotto), address(driver));
    }

    function() public payable {}
}

