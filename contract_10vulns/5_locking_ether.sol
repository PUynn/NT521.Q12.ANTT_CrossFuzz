pragma solidity ^0.4.26;

library SafeMath0426 {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) return 0;
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }
}

contract Vault {
    address public owner;
    uint256 public received;

    event Received(address from, uint256 value);

    constructor() public {
        owner = msg.sender;
    }

    function() public payable {
        received += msg.value;
        emit Received(msg.sender, msg.value);
    }

    function balance() public view returns (uint256) {
        return address(this).balance;
    }
}

contract TokenSale {
    using SafeMath0426 for uint256;

    uint256 public totalSupply;
    uint256 public constant RATE = 10000;
    uint256 public constant MAX_SUPPLY = 22000000 * (10 ** 18);

    mapping(address => uint256) public balanceOf;

    address public owner;
    address public vault;

    event Mint(address indexed buyer, uint256 eth, uint256 tokens);

    constructor(address _vault) public {
        owner = msg.sender;
        vault = _vault;
    }

    function() public payable {
        buy();
    }

    function buy() public payable {
        require(msg.value > 0);
        require(totalSupply < MAX_SUPPLY);

        uint256 tokens = msg.value.mul(RATE);
        balanceOf[msg.sender] = balanceOf[msg.sender].add(tokens);
        totalSupply = totalSupply.add(tokens);

        // ❌ BUG: ETH SHOULD be forwarded to Vault, but is never sent
        // vault.call.value(msg.value)("");

        emit Mint(msg.sender, msg.value, tokens);
    }

    function balance() public view returns (uint256) {
        return address(this).balance;
    }
}

contract Driver {
    TokenSale public sale;

    constructor(address _sale) public {
        sale = TokenSale(_sale);
    }

    function buy() public payable {
        sale.buy.value(msg.value)();
    }

    function tokenBalance(address a) public view returns (uint256) {
        return sale.balanceOf(a);
    }

    function saleEthBalance() public view returns (uint256) {
        return sale.balance();
    }
}

contract Deployer {
    function deploy() public returns (address vaultAddr, address saleAddr, address driverAddr) {
        Vault vault = new Vault();
        TokenSale sale = new TokenSale(address(vault));
        Driver driver = new Driver(address(sale));
        return (address(vault), address(sale), address(driver));
    }

    function() public payable {}
}

