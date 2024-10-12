// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "./IBank.sol";

contract Admin {
    address public owner;

    error OnlyOwnerCanCall();
    error InsufficientBalance(uint256 requested, uint256 available);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert OnlyOwnerCanCall();
        }
        _;
    }

    function adminWithdraw(IBank bank) external onlyOwner {
        uint256 bankBalance = bank.getBalance();
        bank.withdraw(bankBalance);
    }

    receive() external payable { }

    function withdrawFromAdmin(uint256 amount) external onlyOwner {
        if (address(this).balance < amount) {
            revert InsufficientBalance(amount, address(this).balance);
        }
        payable(owner).transfer(amount);
    }
}
