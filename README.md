# Base Network ICO Sniper Proxy

A highly optimized, gas-efficient smart contract and execution script designed for sniping token launches (ICOs/Presales) on the Base L2 network.

## Architecture
The system consists of two parts:
1. **`BaseSniper.sol`**: A lightweight proxy contract. It holds your ETH and executes the arbitrary payload against the target contract. It uses Custom Errors and `viaIR` optimization to minimize execution gas costs.
2. **`snipe.ts`**: An off-chain execution script that bypasses gas estimation by hardcoding `gasLimit` and forces high `maxPriorityFeePerGas` to bribe the Base Sequencer for priority block inclusion.

## Prerequisites
- Node.js >= 18.0.0
- A funded wallet on Base Mainnet.
- A Premium/Private RPC endpoint (Alchemy, QuickNode) for competitive latency. Public RPCs are generally too slow for competitive gas wars.

## Setup

1. **Install dependencies:**
   ```bash
   npm install

2. Environment Configuration:
Copy the example environment file:

Bash
cp .env.example .env
Fill in your .env file:

PRIVATE_KEY: Your wallet's private key.

BASE_RPC_URL: Your private Base Mainnet RPC.

Deployment
Deploy the proxy contract to Base Mainnet:

Bash
npm run deploy
Note down the deployed contract address and add it to your .env file as SNIPER_ADDRESS.

Operation
Fund the Proxy: Send ETH directly to your deployed BaseSniper contract address from your wallet.

Configure Target: Set the TARGET_ADDRESS (the ICO contract) and ETH_AMOUNT in your .env file.

Set Payload: Modify the iface.encodeFunctionData() in scripts/snipe.ts to match the exact ABI of the target contract's purchasing function.

Execute:

Bash
npm run snipe
Post-Execution
After a successful snipe, call withdrawToken(address) and withdrawETH() via a block explorer or a custom script to sweep your assets back to your main wallet.

Disclaimer
This software is provided for educational purposes only. Sniping smart contracts involves significant financial risk. Misconfigured payloads, honeypot contracts, or failed transactions will result in the loss of gas fees or capital. Use at your own risk.
