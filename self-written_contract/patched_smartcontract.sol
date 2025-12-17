// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.4.26;

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;
        return c;
    }
}

contract Sub {
    using SafeMath for uint256;

    mapping(address => uint256) public balances;
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    function addBalances(address _addr, uint256 _amount) public returns (bool) {
        balances[_addr] = balances[_addr].add(_amount);
        return true;
    }

    function withdraw(address _addr, uint256 _amount) public {
        require(balances[_addr] >= _amount, "Not enough balance");
        balances[_addr] = balances[_addr].sub(_amount);
    }

    function deposit() public payable returns (bool) {
        balances[msg.sender] = balances[msg.sender].add(msg.value);
        return true;
    }

    function checkBalance(address _addr) public view returns (uint256) {
        return balances[_addr];
    }
}

contract E {
    using SafeMath for uint256;

    Sub public sub;
    address public owner;
    uint256 public count;
    bool public flag;

    constructor(address _sub) public {
        owner = msg.sender;
        sub = Sub(_sub);
        count = 0;
        flag = false;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    function setSub(address _sub) public onlyOwner {
        require(_sub != address(0), "Invalid address");
        sub = Sub(_sub);
    }

    function setFlag(bool _f) public onlyOwner {
        flag = _f;
    }

    function addBalance(address _addr, uint256 _amount) public {
        require(sub.addBalances(_addr, _amount), "addBalances failed");
        count = count.add(1);
    }

    function deposit() public payable {
        require(sub.deposit.value(msg.value)(), "deposit failed");
    }

    function withdraw(address _addr, uint256 _amount) public {
        sub.withdraw(_addr, _amount);
        count = count.sub(1);
    }

    function getFlag() public view returns (bool) {
        return flag;
    }

    function getCount() public view returns (uint256) {
        return count;
    }
}

// python3 CrossFuzz/fuzzer/main.py -s ./patched_smartcontract.sol -c E --solc v0.4.26 --evm byzantium -t 10 --result ./result/patched/res.json --cross-contract 1 --open-trans-comp 1 --depend-contracts Sub --constructor-args _sub contract Sub --constraint-solving 1 --max-individual-length 10 --solc-path-cross /usr/local/bin/solc --p-open-cross 80 --cross-init-mode 1 --trans-mode 1
