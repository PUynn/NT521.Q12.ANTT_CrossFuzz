pragma solidity ^0.4.26;

contract RewardVault {
    address public owner;

    event Funded(address indexed from, uint256 value);
    event Paid(address indexed to, uint256 value);
    event OwnerChanged(address indexed prev, address indexed next);

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

    function pay(address to, uint256 value) public onlyOwner {
        require(to != address(0));
        require(address(this).balance >= value);
        to.transfer(value);
        emit Paid(to, value);
    }

    function balance() public view returns (uint256) {
        return address(this).balance;
    }
}

contract TokenLedger {
    mapping (address => uint256) public balanceOf;
    mapping (address => uint256) public credit;   // “redeemable” credit
    RewardVault public vault;

    event Mint(address indexed to, uint256 value);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event CreditIssued(address indexed to, uint256 value);
    event Redeemed(address indexed to, uint256 value);

    constructor(address _vault) public {
        require(_vault != address(0));
        vault = RewardVault(_vault);
    }

    function mint(address to, uint256 value) public {
        balanceOf[to] += value;
        emit Mint(to, value);
    }

    function transfer(address _to, uint256 _value) public {
        require(balanceOf[msg.sender] >= _value);
        balanceOf[msg.sender] -= _value;

        // Vulnerability: addition overflow in 0.4.x
        balanceOf[_to] += _value;

        emit Transfer(msg.sender, _to, _value);

        // Cross-contract relevant state: credit follows balanceOf[_to]
        // This can also overflow and later be used to redeem from Vault.
        credit[_to] += _value;
        emit CreditIssued(_to, _value);
    }

    function redeem(uint256 amount) public {
        require(credit[msg.sender] >= amount);
        credit[msg.sender] -= amount;

        // Cross-contract effect: pull ETH from vault (vault owner is this contract)
        vault.pay(msg.sender, amount);
        emit Redeemed(msg.sender, amount);
    }
}

contract Driver {
    TokenLedger public token;

    constructor(address _token) public {
        token = TokenLedger(_token);
    }

    function mintMe(uint256 v) public { token.mint(msg.sender, v); }
    function transferTo(address to, uint256 v) public { token.transfer(to, v); }
    function redeem(uint256 v) public { token.redeem(v); }

    function bal(address a) public view returns (uint256) { return token.balanceOf(a); }
    function credit(address a) public view returns (uint256) { return token.credit(a); }
}

contract Deployer {
    function deploy() public payable returns (address vaultAddr, address tokenAddr, address driverAddr) {
        RewardVault vault = (new RewardVault).value(msg.value)();
        TokenLedger token = new TokenLedger(address(vault));
        vault.setOwner(address(token)); // token becomes vault owner for paying out
        Driver driver = new Driver(address(token));
        return (address(vault), address(token), address(driver));
    }

    function() public payable {}
}

