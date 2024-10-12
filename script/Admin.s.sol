// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "../src/Admin.sol";

contract AdminScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("WALLET_PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        Admin admin = new Admin();

        console2.log("Admin contract deployed to:", address(admin));

        vm.stopBroadcast();
    }
}
