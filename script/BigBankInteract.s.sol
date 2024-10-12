// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Script.sol";
import "../src/BigBank.sol";

contract BigBankInteractScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("WALLET_PRIVATE_KEY");

        address payable deployedBankAddress = payable(vm.envAddress("BANK_CONTRACT_ADDRESS"));
        address payable newAdminAddress = payable(vm.envAddress("USER1_PUBLIC_KEY"));

        vm.startBroadcast(deployerPrivateKey);

        BigBank bigBank = BigBank(deployedBankAddress);

        // deposit 0.002 ether
        bigBank.deposit{ value: 0.002 ether }();
        console.log("Deposited 0.002 ether");

        // get current balance
        uint256 balance = bigBank.getBalance();
        console.log("Current bank balance (in wei):", balance);

        // convert to ETH
        uint256 ethBalance = balance / 1e15; // wei to finney
        uint256 ethWhole = ethBalance / 1000; // finney to ETH
        uint256 ethDecimal = ethBalance % 1000; // finney to ETH

        // print in ETH format
        console.log(
            string.concat(
                "Current bank balance: ",
                vm.toString(ethWhole),
                ".",
                ethDecimal < 100 ? (ethDecimal < 10 ? "00" : "0") : "",
                vm.toString(ethDecimal),
                " ETH"
            )
        );

        // // transfer admin
        // bigBank.transferAdmin(newAdminAddress);
        // console.log("Admin transferred to:", newAdminAddress);

        // verify new admin
        address currentAdmin = bigBank.admin();
        console.log("Current admin:", currentAdmin);

        // query admin balance
        {
            uint256 adminBalance = currentAdmin.balance;
            uint256 ethBalance = adminBalance / 1e15;
            uint256 ethWhole = ethBalance / 1000;
            uint256 ethDecimal = ethBalance % 1000;
            // print in ETH format
            console.log(
                string.concat(
                    "Current admin balance: ",
                    vm.toString(ethWhole),
                    ".",
                    ethDecimal < 100 ? (ethDecimal < 10 ? "00" : "0") : "",
                    vm.toString(ethDecimal),
                    " ETH"
                )
            );
        }

        vm.stopBroadcast();
    }
}
