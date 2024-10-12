# Big bank


## Usage


### Create a ``.env`` file
```
API_KEY_ETHERSCAN=xxx
WALLET_PRIVATE_KEY=xxx
USER1_PUBLIC_KEY=xxx
USER1_PRIVATE_KEY=xxx
USER2_PRIVATE_KEY=xxx
BANK_CONTRACT_ADDRESS=xxx
ADMIN_CONTRACT_ADDRESS=xxx
```

### Deploy BigBank to Anvil
```
forge script script/BigBank.s.sol --fork-url localhost --broadcast
```
```
== Logs ==
  BigBank deployed to: 0xB7f8BC63BbcaD18155201308C8f3540b07f84F5e
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

### Deploy Admin to Anvil
```
forge script script/Admin.s.sol --fork-url localhost --broadcast
```
```
== Logs ==
  Admin contract deployed to: 0x0165878A594ca255338adfa4d48449f69242Eb8F
```

### Interact with Admin
```
forge script script/AdminInteract.s.sol:AdminInteractScript --fork-url localhost --broadcast
```
```
== Logs ==
  Admin contract owner: 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
  Sent 2 ETH to Admin contract
  Withdrawn 1 ETH from Admin contract
  Transferred BigBank admin rights to Admin contract
  Withdrawn 0.1 ETH from BigBank using Admin contract
  Withdrawn all funds from BigBank using Admin contract
  Final Admin contract balance: 2 ETH
  Final BigBank balance: 0 ETH
```
