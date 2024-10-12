// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Test.sol";
import "../src/BigBank.sol";

contract BigBankTest is Test {
    BigBank public bigBank;
    address public admin;
    address public user1;
    address public user2;

    function setUp() public {
        admin = address(this);
        user1 = address(0x1);
        user2 = address(0x2);
        bigBank = new BigBank();
    }

    function testDeposit() public {
        vm.deal(user1, 1 ether);
        vm.prank(user1);
        bigBank.deposit{ value: 0.1 ether }();
        assertEq(bigBank.getDepositAmount(user1), 0.1 ether);
    }

    function testFailDepositTooSmall() public {
        vm.deal(user1, 1 ether);
        vm.prank(user1);
        bigBank.deposit{ value: 0.0009 ether }();
    }

    // function testWithdraw() public {
    //     vm.deal(address(bigBank), 1 ether);
    //     uint256 initialBalance = address(admin).balance;
    //     bigBank.withdraw(0.5 ether);
    //     assertEq(address(admin).balance, initialBalance + 0.5 ether);
    // }

    function testFailWithdrawNotAdmin() public {
        vm.deal(address(bigBank), 1 ether);
        vm.prank(user1);
        bigBank.withdraw(0.5 ether);
    }

    function testTransferAdmin() public {
        bigBank.transferAdmin(user1);
        assertEq(bigBank.admin(), user1);
    }

    function testFailTransferAdminNotAdmin() public {
        vm.prank(user1);
        bigBank.transferAdmin(user2);
    }

    function testCalculateInterest() public {
        vm.deal(user1, 1 ether);
        vm.prank(user1);
        bigBank.deposit{ value: 1 ether }();
        uint256 interest = bigBank.calculateInterest(user1);
        assertEq(interest, 0.05 ether); // 5% of 1 ether
    }

    function testGetTopDepositors() public {
        vm.deal(user1, 2 ether);
        vm.deal(user2, 1 ether);

        vm.prank(user1);
        bigBank.deposit{ value: 2 ether }();

        vm.prank(user2);
        bigBank.deposit{ value: 1 ether }();

        address[3] memory topDepositors = bigBank.getTopDepositors();
        assertEq(topDepositors[0], user1);
        assertEq(topDepositors[1], user2);
        assertEq(topDepositors[2], address(0));
    }
}
