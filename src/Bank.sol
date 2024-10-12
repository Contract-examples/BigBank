// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "./IBank.sol";

// We can't deploy this contract directly, because it is abstract
abstract contract Bank is IBank {
    address public admin;
    mapping(address => uint256) public balances;
    address[3] public topDepositors;

    // Custom errors
    error DepositTooLow();
    error OnlyAdminCanWithdraw();

    constructor() {
        admin = msg.sender;
    }

    // Receive ETH
    receive() external payable {
        // Call deposit function
        deposit();
    }

    // Update top 3 depositors
    function updateTopDepositors(address depositor) private {
        uint256 depositAmount = balances[depositor];
        uint256 index = 3;

        for (uint256 i = 0; i < 3; i++) {
            if (depositAmount > balances[topDepositors[i]]) {
                index = i;
                break;
            }
        }

        if (index < 3) {
            for (uint256 i = 2; i > index; i--) {
                topDepositors[i] = topDepositors[i - 1];
            }
            topDepositors[index] = depositor;
        }
    }

    // Abstract function to calculate interest
    function calculateInterest(address user) public view virtual returns (uint256);

    // Deposit function
    function deposit() public payable virtual override {
        if (msg.value == 0) {
            revert DepositTooLow();
        }
        balances[msg.sender] += msg.value;
        updateTopDepositors(msg.sender);
    }

    // Withdrawal function (only callable by admin)
    function withdraw(uint256 amount) external virtual override {
        // Revert if caller is not admin
        if (msg.sender != admin) {
            revert OnlyAdminCanWithdraw();
        }
        // If the requested amount is greater than the balance, set amount to the balance
        uint256 balance = address(this).balance;
        amount = amount > balance ? balance : amount;
        if (amount != 0) {
            payable(admin).transfer(amount);
        }
    }

    function getBalance() public view virtual override returns (uint256) {
        return address(this).balance;
    }

    function getTopDepositors() public view virtual override returns (address[3] memory) {
        return topDepositors;
    }

    function getDepositAmount(address depositor) public view virtual override returns (uint256) {
        return balances[depositor];
    }
}
