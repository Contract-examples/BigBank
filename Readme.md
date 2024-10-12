# Big bank


## Usage


### Create a ``.env`` file
```

API_KEY_INFURA=your infura api key [Used for sepolia testnet]
API_KEY_ETHERSCAN=your etherscan api key [Used for sepolia testnet]
WALLET_PRIVATE_KEY=your wallet private key [Used for BankInteract.s.sol/Bank.s.sol]
USER1_PRIVATE_KEY=private key of user1 [Used for BankInteract.s.sol]
USER2_PRIVATE_KEY=private key of user2 [Used for BankInteract.s.sol]
SEPOLIA_WALLET_PRIVATE_KEY=your wallet private key [Used for BankSepolia.s.sol/Bank.s.sol]
BANK_CONTRACT_ADDRESS=your contract address [Used for BankSepoliaInteract.s.sol]
```

### Deploy BigBank to Anvil
```
forge script script/BigBank.s.sol --fork-url localhost --broadcast
```

