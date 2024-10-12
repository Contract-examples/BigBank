// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "./Bank.sol";

contract BigBank is Bank {
    error DepositTooSmall();
    error OnlyAdminCanTransfer();
    error InvalidAdminAddress();

    // 5% annual interest rate (big bank)
    uint256 public constant INTEREST_RATE = 5;

    // Modifier to ensure the deposit amount is greater than 0.001 ether
    modifier minDeposit() {
        if (msg.value <= 0.001 ether) {
            revert DepositTooSmall();
        }
        _;
    }

    // Override the deposit function from the Bank contract
    function deposit() public payable virtual override minDeposit {
        super.deposit();
    }

    // External function to transfer the admin role
    function transferAdmin(address newAdmin) external {
        if (msg.sender != admin) {
            revert OnlyAdminCanTransfer();
        }
        if (newAdmin == address(0)) {
            revert InvalidAdminAddress();
        }
        admin = newAdmin;
    }

    // Implementation of the abstract function
    function calculateInterest(address user) public view override returns (uint256) {
        uint256 userBalance = balances[user];
        return (userBalance * INTEREST_RATE) / 100;
    }
}
