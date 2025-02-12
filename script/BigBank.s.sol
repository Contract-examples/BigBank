// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "../src/BigBank.sol";

contract BigBankScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("WALLET_PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        BigBank bigBank = new BigBank();

        console2.log("BigBank deployed to:", address(bigBank));

        vm.stopBroadcast();
    }
}
