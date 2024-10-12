// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

// Interface for the Bank contract
interface IBank {
    // Function to deposit funds into the bank
    function deposit() external payable;
    // Function to withdraw funds from the bank
    function withdraw(uint256 amount) external;
    // Function to get the current balance of the bank
    function getBalance() external view returns (uint256);
    // Function to get the top 3 depositors
    function getTopDepositors() external view returns (address[3] memory);
    // Function to get the deposit amount for a specific depositor
    function getDepositAmount(address depositor) external view returns (uint256);
}
