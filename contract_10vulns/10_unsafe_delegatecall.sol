pragma solidity ^0.4.26;

contract Vault {
    address public owner;

    event Funded(address from, uint256 value);
    event OwnerChanged(address prev, address next);
    event Drained(address to, uint256 value);

    constructor() public payable {
        owner = msg.sender;
        if (msg.value > 0) emit Funded(msg.sender, msg.value);
    }

    modifier onlyOwner() { require(msg.sender == owner); _; }

    function() public payable { emit Funded(msg.sender, msg.value); }

    function setOwner(address next) public onlyOwner {
        require(next != address(0));
        emit OwnerChanged(owner, next);
        owner = next;
    }

    function drainTo(address to) public onlyOwner {
        uint256 v = address(this).balance;
        to.transfer(v);
        emit Drained(to, v);
    }
}

contract Proxy {
    address public owner;
    address public impl;

    event Upgraded(address impl);
    event OwnerChanged(address prev, address next);

    constructor(address _impl) public {
        owner = msg.sender;
        impl = _impl;
        emit OwnerChanged(address(0), owner);
        emit Upgraded(_impl);
    }

    modifier onlyOwner() { require(msg.sender == owner); _; }

    function upgradeTo(address _impl) public onlyOwner {
        impl = _impl;
        emit Upgraded(_impl);
    }

    function forward(address callee, bytes _data) public {
        require(callee.delegatecall(_data));
    }

    
    function() public payable {
        address _impl = impl;
        require(_impl != address(0));
        assembly {
            calldatacopy(0, 0, calldatasize)
            let ok := delegatecall(gas, _impl, 0, calldatasize, 0, 0)
            let size := returndatasize
            returndatacopy(0, 0, size)
            switch ok
            case 0 { revert(0, size) }
            default { return(0, size) }
        }
    }
}

contract LogicV1 {
    address public admin; 

    event AdminSet(address a);

    function pwn() public {
        admin = msg.sender; // via delegatecall => Proxy.owner = msg.sender
        emit AdminSet(admin);
    }

    function setAdmin(address a) public {
        admin = a; 
        emit AdminSet(a);
    }
}

contract LogicWithVault {
    Vault public vault; 

    constructor(address _vault) public {
        vault = Vault(_vault);
    }

    function drain(address to) public {
        vault.drainTo(to);
    }

    function setVaultOwner(address next) public {
        vault.setOwner(next);
    }
}

contract Driver {
    Proxy public proxy;
    Vault public vault;

    constructor(address _proxy, address _vault) public {
        proxy = Proxy(_proxy);
        vault = Vault(_vault);
    }

    function forward(address callee, bytes data) public {
        proxy.forward(callee, data);
    }

    function upgrade(address impl) public {
        proxy.upgradeTo(impl);
    }

    function callProxy(bytes data) public payable {
        address(proxy).call.value(msg.value)(data);
    }

    function vaultBalance() public view returns (uint256) {
        return address(vault).balance;
    }
}

contract Deployer {
    function deploy() public payable
        returns (address vaultAddr, address logic1Addr, address proxyAddr, address driverAddr)
    {
        Vault vault = (new Vault).value(msg.value)();

        LogicV1 logic1 = new LogicV1();
        Proxy proxy = new Proxy(address(logic1));
        vault.setOwner(address(proxy));

        Driver driver = new Driver(address(proxy), address(vault));
        return (address(vault), address(logic1), address(proxy), address(driver));
    }

    function() public payable {}
}

