// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

interface IBank {
    function deposit() external payable;
    function withdraw(uint256 amount) external;
    function getBalance() external view returns (uint256);
    function getTopDepositors() external view returns (address[3] memory);
    function getDepositAmount(address depositor) external view returns (uint256);
}
