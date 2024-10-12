// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Script.sol";
import "../src/Admin.sol";
import "../src/BigBank.sol";

contract AdminInteractScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("WALLET_PRIVATE_KEY");
        address payable adminAddress = payable(vm.envAddress("ADMIN_CONTRACT_ADDRESS"));
        address payable bigBankAddress = payable(vm.envAddress("BANK_CONTRACT_ADDRESS"));

        vm.startBroadcast(deployerPrivateKey);

        Admin admin = Admin(adminAddress);
        BigBank bigBank = BigBank(bigBankAddress);

        // Query Admin contract owner
        address owner = admin.owner();
        console2.log("Admin contract owner:", owner);

        // Send some ETH to Admin contract
        (bool sent,) = adminAddress.call{ value: 2 ether }("");
        require(sent, "Failed to send Ether to Admin contract");
        console2.log("Sent 2 ETH to Admin contract");

        // Withdraw some funds from Admin contract
        uint256 withdrawAmount = 1 ether;
        admin.withdrawFromAdmin(withdrawAmount);
        console2.log("Withdrawn", withdrawAmount / 1e18, "ETH from Admin contract");

        // Transfer BigBank admin rights to Admin contract
        bigBank.transferAdmin(adminAddress);
        console2.log("Transferred BigBank admin rights to Admin contract");

        // Withdraw funds from BigBank using Admin contract
        admin.adminWithdraw(bigBank, 0.1 ether);
        console2.log("Withdrawn 0.1 ETH from BigBank using Admin contract");

        // Withdraw all funds from BigBank using Admin contract
        admin.adminWithdrawAll(bigBank);
        console2.log("Withdrawn all funds from BigBank using Admin contract");

        // Query final balances
        uint256 adminBalance = adminAddress.balance;
        uint256 bigBankBalance = bigBankAddress.balance;
        console2.log("Final Admin contract balance:", adminBalance / 1e18, "ETH");
        console2.log("Final BigBank balance:", bigBankBalance / 1e18, "ETH");

        vm.stopBroadcast();
    }
}
