// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "./IBank.sol";

contract Admin {
    address public owner;

    // Custom error
    error OnlyOwnerCanCall();

    constructor() {
        owner = msg.sender;
    }

    // Receive function to allow the admin contract to receive ETH
    receive() external payable { }

    // Modifier to ensure only the owner can call a function
    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert OnlyOwnerCanCall();
        }
        _;
    }

    // External function to withdraw funds from the admin contract
    function withdrawFromAdmin(uint256 amount) external onlyOwner {
        if (address(this).balance < amount) {
            // If the requested amount is greater than the balance,
            // set amount to the balance
            amount = address(this).balance;
        }
        // Transfer the amount to the owner
        payable(owner).transfer(amount);
    }

    // Internal function to withdraw funds from a bank
    function _withdrawFromBank(IBank bank, uint256 amount) internal onlyOwner {
        uint256 bankBalance = bank.getBalance();
        if (bankBalance > 0) {
            bank.withdraw(amount == 0 || amount > bankBalance ? bankBalance : amount);
        }
    }

    // External function to withdraw a specified amount of funds from a bank
    function adminWithdraw(IBank bank, uint256 amount) external {
        _withdrawFromBank(bank, amount);
    }

    // External function to withdraw all funds from a bank
    function adminWithdrawAll(IBank bank) external {
        _withdrawFromBank(bank, 0);
    }
}