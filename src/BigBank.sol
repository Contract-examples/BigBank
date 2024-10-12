// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "./Bank.sol";

contract BigBank is Bank {
    error DepositTooSmall();
    error OnlyAdminCanTransfer();
    error InvalidAdminAddress();

    modifier minDeposit() {
        if (msg.value <= 0.001 ether) {
            revert DepositTooSmall();
        }
        _;
    }

    function deposit() public payable virtual override minDeposit {
        super.deposit();
    }

    function transferAdmin(address newAdmin) external {
        // Revert if caller is not admin
        if (msg.sender != admin) {
            revert OnlyAdminCanTransfer();
        }
        // Revert if new admin address is zero
        if (newAdmin == address(0)) {
            revert InvalidAdminAddress();
        }
        // Transfer admin rights
        admin = newAdmin;
    }
}
