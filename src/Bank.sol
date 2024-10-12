// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "./IBank.sol";

contract Bank is IBank {
    address public admin;
    mapping(address => uint256) public balances;
    address[3] public topDepositors;

    // Custom errors
    error DepositTooLow();
    error OnlyAdminCanWithdraw();
    error InsufficientBalance(uint256 requested, uint256 available);

    constructor() {
        admin = msg.sender;
    }

    // Receive ETH
    receive() external payable {
        // Call deposit function
        deposit();
    }

    // Deposit function
    // Use virtual to allow overriding in derived contracts
    // Use override to ensure the function is implemented in derived contracts
    function deposit() public payable virtual override {
        // Revert if deposit amount is 0
        if (msg.value == 0) {
            revert DepositTooLow();
        }
        balances[msg.sender] += msg.value;
        updateTopDepositors(msg.sender);
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

    // Withdrawal function (only callable by admin)
    function withdraw(uint256 amount) external virtual override {
        // Revert if caller is not admin
        if (msg.sender != admin) {
            revert OnlyAdminCanWithdraw();
        }
        // Revert if requested amount exceeds balance
        if (amount > address(this).balance) {
            revert InsufficientBalance(amount, address(this).balance);
        }
        payable(admin).transfer(amount);
    }

    // Query contract balance
    function getBalance() public view virtual override returns (uint256) {
        return address(this).balance;
    }

    // Query top 3 depositors
    function getTopDepositors() public view virtual override returns (address[3] memory) {
        return topDepositors;
    }

    // Function to get deposit amount for a specific depositor
    function getDepositAmount(address depositor) public view virtual override returns (uint256) {
        return balances[depositor];
    }
}

contract BigBank is Bank {
    // Use modifier to enforce deposit size
    modifier minDeposit() {
        // Revert if deposit amount is too small
        if (msg.value <= 0.001 ether) {
            revert DepositTooSmall();
        }
        _;
    }

    // Override deposit function to enforce deposit size
    function deposit() public payable virtual override minDeposit {
        // Call parent deposit function
        super.deposit();
    }

    // Function to transfer admin rights
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

contract Admin {
    address public owner;

    // Custom error
    error OnlyOwnerCanCall();
    error InsufficientBalance(uint256 requested, uint256 available);

    constructor() {
        owner = msg.sender;
    }

    // Modifier to enforce owner only
    modifier onlyOwner() {
        // Revert if caller is not owner
        if (msg.sender != owner) {
            revert OnlyOwnerCanCall();
        }
        _;
    }

    // Function to withdraw from bank
    function adminWithdraw(IBank bank) external onlyOwner {
        uint256 bankBalance = bank.getBalance();
        bank.withdraw(bankBalance);
    }

    // Receive ETH
    receive() external payable { }

    // Function to withdraw from Admin contract
    function withdrawFromAdmin(uint256 amount) external onlyOwner {
        // Revert if balance is insufficient
        if (address(this).balance < amount) {
            revert InsufficientBalance(amount, address(this).balance);
        }

        // Transfer funds to owner
        payable(owner).transfer(amount);
    }
}
