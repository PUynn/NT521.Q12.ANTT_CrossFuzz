pragma solidity ^0.4.26;

contract Target {
    uint256 public funds;
    address public owner;

    event Funded(address from, uint256 value);
    event Destroyed(address to);

    constructor() public payable {
        owner = msg.sender;
        if (msg.value > 0) {
            funds += msg.value;
            emit Funded(msg.sender, msg.value);
        }
    }

    function() public payable {
        funds += msg.value;
        emit Funded(msg.sender, msg.value);
    }

   
    function destroyAnyone() public {
        emit Destroyed(msg.sender);
        selfdestruct(msg.sender);
    }

    function balance() public view returns (uint256) {
        return address(this).balance;
    }
}

contract Controller {
    Target public target;
    uint256 public recordedBalance;

    event Synced(uint256 v);
    event Paid(address to, uint256 v);

    constructor(address _target) public {
        target = Target(_target);
    }

    function sync() public {
        recordedBalance = target.balance();
        emit Synced(recordedBalance);
    }

    function pay(address to, uint256 amount) public {
        require(recordedBalance >= amount);

        // assumes target still exists
        target.balance();

        to.transfer(amount);
        recordedBalance -= amount;
        emit Paid(to, amount);
    }
}

contract Driver {
    Controller public controller;
    Target public target;

    constructor(address _controller, address _target) public {
        controller = Controller(_controller);
        target = Target(_target);
    }

    function sync() public {
        controller.sync();
    }

    function destroyTarget() public {
        target.destroyAnyone();
    }

    function pay(address to, uint256 v) public {
        controller.pay(to, v);
    }
}

contract Deployer {
    function deploy() public payable
        returns (address targetAddr, address controllerAddr, address driverAddr)
    {
        Target target = (new Target).value(msg.value)();
        Controller controller = new Controller(address(target));
        Driver driver = new Driver(address(controller), address(target));
        return (address(target), address(controller), address(driver));
    }

    function() public payable {}
}

