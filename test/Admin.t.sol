// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Test.sol";
import "forge-std/console2.sol";
import "../src/Admin.sol";
import "../src/BigBank.sol";

contract AdminTest is Test {
    Admin public admin;
    BigBank public bigBank;
    address public owner;
    address public user;

    function setUp() public {
        owner = address(this);
        user = address(0x1);
        admin = new Admin();
        bigBank = new BigBank();
    }

    function testOwnership() public {
        assertEq(admin.owner(), owner);
    }

    function testWithdrawFromAdmin() public {
        // Fund the Admin contract
        vm.deal(address(admin), 1 ether);

        uint256 initialBalance = owner.balance;
        console2.log("Initial owner balance:", initialBalance);
        console2.log("Initial admin balance:", address(admin).balance);

        admin.withdrawFromAdmin(0.5 ether);
        console2.log("Final owner balance:", owner.balance);
        console2.log("Final admin balance:", address(admin).balance);

        assertEq(owner.balance, initialBalance + 0.5 ether);
        assertEq(address(admin).balance, 0.5 ether);
    }

    function testWithdrawAllFromAdmin() public {
        vm.deal(address(admin), 1 ether);

        uint256 initialOwnerBalance = owner.balance;
        uint256 initialAdminBalance = address(admin).balance;

        console2.log("Initial owner balance:", initialOwnerBalance);
        console2.log("Initial admin balance:", initialAdminBalance);

        admin.withdrawFromAdmin(0); // 0 means withdraw all

        uint256 finalOwnerBalance = owner.balance;
        uint256 finalAdminBalance = address(admin).balance;

        console2.log("Final owner balance:", finalOwnerBalance);
        console2.log("Final admin balance:", finalAdminBalance);

        assertEq(finalOwnerBalance, initialOwnerBalance + 1 ether, "Owner balance did not increase by 1 ether");
        assertEq(finalAdminBalance, 0, "Admin balance is not zero");
    }

    function testFailWithdrawFromAdminNotOwner() public {
        vm.prank(user);
        admin.withdrawFromAdmin(1 ether);
    }

    function testAdminWithdrawFromBank() public {
        // Fund the BigBank contract
        vm.deal(address(bigBank), 1 ether);

        // Transfer BigBank admin rights to Admin contract
        bigBank.transferAdmin(address(admin));

        uint256 initialBalance = address(admin).balance;
        console2.log("Initial admin balance:", initialBalance);
        console2.log("Initial bank balance:", address(bigBank).balance);

        admin.adminWithdraw(bigBank, 0.5 ether);
        console2.log("Final admin balance:", address(admin).balance);
        console2.log("Final bank balance:", address(bigBank).balance);

        assertEq(address(admin).balance, initialBalance + 0.5 ether);
        assertEq(address(bigBank).balance, 0.5 ether);
    }

    function testAdminWithdrawAllFromBank() public {
        vm.deal(address(bigBank), 1 ether);
        bigBank.transferAdmin(address(admin));

        uint256 initialBalance = address(admin).balance;
        console2.log("Initial admin balance:", initialBalance);
        console2.log("Initial bank balance:", address(bigBank).balance);

        admin.adminWithdrawAll(bigBank);

        console2.log("Final admin balance:", address(admin).balance);
        console2.log("Final bank balance:", address(bigBank).balance);

        assertEq(address(admin).balance, initialBalance + 1 ether);
        assertEq(address(bigBank).balance, 0);
    }

    function testFailAdminWithdrawFromBankNotOwner() public {
        vm.prank(user);
        admin.adminWithdraw(bigBank, 1 ether);
    }

    receive() external payable { }
}
