pragma solidity ^0.4.26;

library SafeMath0426 {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);
        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        return a - b;
    }
}

contract SimpleToken {
    using SafeMath0426 for uint256;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 v);
    event Approval(address indexed o, address indexed s, uint256 v);

    constructor(uint256 supply) public {
        balanceOf[msg.sender] = supply;
    }

    function transfer(address to, uint256 v) public returns (bool) {
        require(v <= balanceOf[msg.sender]);
        balanceOf[msg.sender] = balanceOf[msg.sender].sub(v);
        balanceOf[to] = balanceOf[to].add(v);
        emit Transfer(msg.sender, to, v);
        return true;
    }

    
    function approve(address spender, uint256 v) public returns (bool) {
        allowance[msg.sender][spender] = v;
        emit Approval(msg.sender, spender, v);
        return true;
    }

    function transferFrom(address from, address to, uint256 v) public returns (bool) {
        require(v <= balanceOf[from]);
        require(v <= allowance[from][msg.sender]);

        balanceOf[from] = balanceOf[from].sub(v);
        balanceOf[to] = balanceOf[to].add(v);
        allowance[from][msg.sender] = allowance[from][msg.sender].sub(v);

        emit Transfer(from, to, v);
        return true;
    }
}

contract Exchange {
    SimpleToken public token;
    mapping(address => uint256) public credit;

    event Deposited(address who, uint256 amount);
    event Settled(address who, uint256 amount);

    constructor(address _token) public {
        token = SimpleToken(_token);
    }

    function() public payable {}

    function settle(address user, uint256 amount) public {
        require(amount > 0);

        // pulls token via allowance
        require(token.transferFrom(user, address(this), amount));
        credit[user] += amount;

        emit Settled(user, amount);
    }

    function withdraw() public {
        uint256 v = credit[msg.sender];
        require(v > 0);
        credit[msg.sender] = 0;
        msg.sender.transfer(v);
    }
}

contract Driver {
    SimpleToken public token;
    Exchange public exchange;

    constructor(address _token, address _exchange) public {
        token = SimpleToken(_token);
        exchange = Exchange(_exchange);
    }

    function approve(uint256 v) public {
        token.approve(address(exchange), v);
    }

    function settle(uint256 v) public {
        exchange.settle(msg.sender, v);
    }

    function withdraw() public {
        exchange.withdraw();
    }

    function balance(address a) public view returns (uint256) {
        return token.balanceOf(a);
    }
}

contract Deployer {
    function deploy(uint256 supply) public payable
        returns (address tokenAddr, address exchangeAddr, address driverAddr)
    {
        SimpleToken token = new SimpleToken(supply);
        Exchange exchange = new Exchange(address(token));
        Driver driver = new Driver(address(token), address(exchange));

        if (msg.value > 0) {
            address(exchange).transfer(msg.value);
        }

        return (address(token), address(exchange), address(driver));
    }

    function() public payable {}
}

