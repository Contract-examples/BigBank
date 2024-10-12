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
  BigBank deployed to: 0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9
```

### Interact with BigBank
```
forge script script/BigBankInteract.s.sol:BigBankInteractScript --fork-url localhost --broadcast
```
```
== Logs ==
  Deposited 0.002 ether
  Current bank balance: 0.20 ETH
  Admin transferred to: 0x70997970C51812dc3A010C7d01b50e0d17dc79C8
  Current admin: 0x70997970C51812dc3A010C7d01b50e0d17dc79C8
```
