// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.4.26;

contract Sub {
    mapping(address => uint256) public balances;
    address public owner;

    function Sub() public {
        owner = msg.sender;
    }

    function addBalances(address _addr, uint256 _amount) public returns (bool) {
        balances[_addr] += _amount;
        return true;
    }

    function withdraw(address _addr, uint256 _amount) public returns (bool) {
        require(balances[_addr] >= _amount);
        balances[_addr] -= _amount;
        return true;
    }

    function deposit() public payable returns (bool) {
        balances[msg.sender] += msg.value;
        return true;
    }

    function checkBalance(address _addr) public view returns (uint256) {
        return balances[_addr];
    }
}

contract E {
    Sub public sub;
    address public owner;
    uint256 public count;
    bool public flag;

    function E(address _sub) public {
        owner = msg.sender;
        sub = Sub(_sub);
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function setSub(address _sub) public onlyOwner {
        sub = Sub(_sub);
    }

    function setCount(uint256 _c) public {
        count = _c;
    }

    function setFlag(bool _f) public {
        flag = _f;
    }

    function addBalance(address _addr, uint256 _amount) public {
        require(sub.addBalances(_addr, _amount), "addBalances failed");
        count++;
    }

    function deposit() public payable {
        bool ok = sub.deposit.value(msg.value)();
        require(ok, "deposit failed");
    }

    function withdraw(address _addr, uint256 _amount) public {
        require(sub.withdraw(_addr, _amount), "withdraw failed");
        count--; // Integer overflow
    }

    function getFlag() public view returns (bool) {
        return flag;
    }
}

// python3 CrossFuzz/fuzzer/main.py -s ./vulnerable_smartcontract.sol -c E --solc v0.4.26 --evm byzantium -t 10 --result ./result/vulnerable/res.json --cross-contract 1 --open-trans-comp 1 --depend-contracts Sub --constructor-args _sub contract Sub --constraint-solving 1 --max-individual-length 10 --solc-path-cross /usr/local/bin/solc --p-open-cross 80 --cross-init-mode 1 --trans-mode 1