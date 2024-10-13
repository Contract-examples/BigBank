// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "./IBank.sol";

contract Admin {
    address public owner;

    // Constant to represent withdrawing all funds
    uint256 private constant WITHDRAW_ALL = type(uint256).max;

    // Custom error
    error OnlyOwnerCanCall();
    error WithdrawalFailed();
    
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
        uint256 balance = address(this).balance;
        amount = amount == 0 ? balance : (amount > balance ? balance : amount);
        if (amount > 0) {
            (bool success, ) = payable(owner).call{value: amount}("");
            if (!success) {
                revert WithdrawalFailed();
            }
        }
    }

    // Internal function to withdraw funds from a bank
    function _withdrawFromBank(IBank bank, uint256 amount) internal onlyOwner {
        uint256 bankBalance = bank.getBalance();
        if (bankBalance > 0) {
            bank.withdraw(amount == WITHDRAW_ALL || amount > bankBalance ? bankBalance : amount);
        }
    }

    // External function to withdraw a specified amount of funds from a bank
    function adminWithdraw(IBank bank, uint256 amount) external {
        _withdrawFromBank(bank, amount);
    }

    // External function to withdraw all funds from a bank
    function adminWithdrawAll(IBank bank) external {
        _withdrawFromBank(bank, WITHDRAW_ALL);
    }
}
