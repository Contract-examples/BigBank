# Big bank


## Usage


### Create a ``.env`` file
```
WALLET_PRIVATE_KEY=your wallet private key [Used for BankInteract.s.sol/Bank.s.sol]
USER1_PRIVATE_KEY=private key of user1 [Used for BankInteract.s.sol]
USER2_PRIVATE_KEY=private key of user2 [Used for BankInteract.s.sol]
BANK_CONTRACT_ADDRESS=your contract address [Used for BankSepoliaInteract.s.sol]
```

### Deploy BigBank to Anvil
```
forge script script/BigBank.s.sol --fork-url localhost --broadcast
```
```
== Logs ==
  BigBank deployed to: 0x5FbDB2315678afecb367f032d93F642f64180aa3
```

```
forge script script/BigBankInteract.s.sol:BigBankInteractScript --fork-url localhost --broadcast
```
```
== Logs ==
  Deposited 0.002 ether
  Current bank balance: 2000000000000000
  Admin transferred to: 0x1234567890123456789012345678901234567890
  Current admin: 0x1234567890123456789012345678901234567890
```
