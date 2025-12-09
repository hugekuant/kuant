# Kuant - Futures Margin Pool

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Solidity](https://img.shields.io/badge/Solidity-0.6.12-blue.svg)](https://docs.soliditylang.org/)
[![Hardhat](https://img.shields.io/badge/Built%20with-Hardhat-orange.svg)](https://hardhat.org/)

A decentralized futures margin pool smart contract system built on EVM-compatible blockchains.

## Overview

Kuant is a smart contract-based system for managing futures trading margin pools. The `FuturesMarginPoolClassics` contract allows users to deposit margin tokens, manage withdrawals, and track user balances for futures trading operations.

### Key Features

- **Margin Deposits**: Users can deposit ERC20 tokens as margin collateral
- **Controlled Withdrawals**: Secure withdrawal system with admin oversight
- **Balance Tracking**: Comprehensive tracking of user deposits and withdrawals
- **Reentrancy Protection**: Built-in protection against reentrancy attacks
- **Admin Management**: Flexible admin role management system
- **Fee Collection**: Configurable fee collection on withdrawals

## Architecture

### Smart Contracts

#### FuturesMarginPoolClassics

The main contract that manages the margin pool operations.

**Location:** `contracts/FuturesMarginPoolClassics.sol`

**Key Components:**
- User deposit and withdrawal management
- Admin role-based access control
- Fee collection mechanism
- Balance accounting system

**State Variables:**
- `marginCoinAddress`: The ERC20 token used for margin deposits
- `admin`: Primary administrator address
- `withdrawAdmin`: Address authorized to process withdrawals
- `vaults`: Treasury/vault address for protocol funds
- `feeAddress`: Address that receives withdrawal fees

**Main Functions:**
- `deposit(uint256 depositAmount, bytes32 depositHash)`: Deposit margin tokens
- `withdraw(address account, uint256 withdrawAmount, uint256 fee, bytes32 withdrawHash)`: Process user withdrawals
- `withdrawAdminFun(uint256 withdrawAmount)`: Admin function to move funds to vaults
- `getUserAddressBalance()`: View user's deposit and withdrawal totals

## Security

### Security Audit

A comprehensive security audit has been conducted on the smart contracts. Please review the audit report before any deployment:

**[Security Audit Report](./SECURITY_AUDIT_REPORT.md)**

**[Security Audit PDF Report](./Kuant.ai_202511251702.pdf)** - Detailed audit documentation

**Current Security Status:** ⚠️ **NOT PRODUCTION READY**

**Critical Issues Identified:** 10 Critical, 5 High, 4 Medium, 3 Low

**Key Security Concerns:**
- Unrestricted admin fund access
- Missing balance validation in withdrawals
- Outdated Solidity version (0.6.12)
- Centralization risks
- No emergency pause mechanism

**Recommendation:** Do NOT deploy to production until critical vulnerabilities are addressed and a professional external audit is completed.

## Technology Stack

### Dependencies

- **Solidity**: ^0.6.12
- **Hardhat**: ^2.26.3
- **OpenZeppelin Contracts**: 3.4.1
- **LayerZero V2**: Cross-chain messaging protocol
- **Stargate Finance**: Cross-chain bridge integration
- **Aave V3**: DeFi lending protocol integration

### Development Tools

- **TypeScript**: Type-safe development
- **Chai**: Testing framework
- **Mocha**: Test runner
- **Hardhat Toolbox**: Comprehensive development suite

## Installation

### Prerequisites

- Node.js >= 16.x
- pnpm >= 10.8.0

### Setup

```bash
# Clone the repository
git clone https://github.com/hugekuant/kuant.git
cd kuant

# Install dependencies
pnpm install

# Create environment file
cp .env.example .env
# Edit .env with your configuration
```

### Environment Variables

Create a `.env` file in the root directory:

```bash
PRIVATE_KEY=your_private_key_here
BSC_RPC_URL=https://bsc-dataseed.binance.org/
BSC_TESTNET_RPC_URL=https://data-seed-prebsc-1-s1.binance.org:8545/
```

## Usage

### Compile Contracts

```bash
npx hardhat compile
```

### Run Tests

```bash
npx hardhat test
```

### Test with Gas Reporting

```bash
REPORT_GAS=true npx hardhat test
```

### Deploy Locally

```bash
npx hardhat node
```

In another terminal:

```bash
npx hardhat run scripts/deploy.js --network localhost
```

### Deploy to BSC Testnet

```bash
npx hardhat run scripts/deploy.js --network bscTestnet
```

### Deploy to BSC Mainnet

```bash
npx hardhat run scripts/deploy.js --network bsc
```

## Network Support

### Configured Networks

- **Hardhat Local**: localhost:8545 (Chain ID: 1337)
- **BSC Mainnet**: Binance Smart Chain
- **BSC Testnet**: Binance Smart Chain Testnet

### Contract Addresses

| Network | Contract | Address |
|---------|----------|---------|
| BSC Mainnet | FuturesMarginPoolClassics | [`0xf6ae4e36a14da4be1988911d5e03544dc35dff3a`](https://bscscan.com/address/0xf6ae4e36a14da4be1988911d5e03544dc35dff3a) |
| BSC Testnet | FuturesMarginPoolClassics | TBD |

## Development

### Project Structure

```
kuant/
├── contracts/               # Smart contracts
│   └── FuturesMarginPoolClassics.sol
├── test/                    # Test files
├── scripts/                 # Deployment scripts
├── hardhat.config.js        # Hardhat configuration
├── package.json             # Dependencies
├── README.md               # This file
├── LICENSE                 # MIT License
└── SECURITY_AUDIT_REPORT.md # Security audit report
```

### Clean Build Artifacts

```bash
pnpm run clean
```

### Compile Contracts

```bash
pnpm run compile
```

### Run Tests

```bash
pnpm run test
```

## Contract Interaction

### Deposit Margin

```javascript
const tx = await marginPool.deposit(
  ethers.utils.parseEther("100"), // Amount
  ethers.utils.id("unique-deposit-hash") // Deposit hash
);
await tx.wait();
```

### Check User Balance

```javascript
const [inAmount, outAmount] = await marginPool.getUserAddressBalance();
console.log(`Deposits: ${ethers.utils.formatEther(inAmount)}`);
console.log(`Withdrawals: ${ethers.utils.formatEther(outAmount)}`);
```

### Process Withdrawal (Admin Only)

```javascript
const tx = await marginPool.withdraw(
  userAddress,
  ethers.utils.parseEther("50"), // Amount
  ethers.utils.parseEther("0.5"), // Fee
  ethers.utils.id("unique-withdrawal-hash")
);
await tx.wait();
```

## Security Best Practices

### For Users

1. Always verify contract addresses before interacting
2. Start with small test transactions
3. Monitor your balance regularly
4. Keep your private keys secure
5. Be aware of the centralization risks

### For Developers

1. Review the security audit report thoroughly
2. Address all critical vulnerabilities before deployment
3. Implement comprehensive testing
4. Use multi-signature wallets for admin roles
5. Set up monitoring and alerting systems
6. Implement timelock for critical operations
7. Consider upgrading to Solidity 0.8.x
8. Get professional external audit before mainnet deployment

## Known Issues

See [SECURITY_AUDIT_REPORT.md](./SECURITY_AUDIT_REPORT.md) for comprehensive list of security issues and recommendations.

**Critical Issues:**
- C-01: Unrestricted fund drainage via withdrawAdminFun
- C-02: No balance validation in withdrawal function
- C-03: Admin can change token address and steal funds
- C-04: Excessive fee extraction possible
- C-05: Single admin can change own address
- C-06: Outdated Solidity version
- C-07: No emergency stop mechanism
- C-08: Inconsistent balance accounting
- C-09: Missing access control events
- C-10: Complete trust in admins (centralization risk)

## Roadmap

### Phase 1: Security Hardening (Current)
- [ ] Address all critical vulnerabilities
- [ ] Upgrade to Solidity 0.8.20+
- [ ] Implement emergency pause mechanism
- [ ] Add comprehensive balance validation
- [ ] Implement multi-signature admin controls

### Phase 2: Feature Enhancement
- [ ] User-initiated withdrawal requests
- [ ] Signature-based withdrawal authorization
- [ ] Batch deposit/withdrawal operations
- [ ] Governance mechanism
- [ ] Timelock for critical operations

### Phase 3: Testing & Audit
- [ ] Comprehensive test suite (unit, integration, e2e)
- [ ] Fuzzing and invariant testing
- [ ] Professional external security audit
- [ ] Bug bounty program
- [ ] Formal verification

### Phase 4: Deployment
- [ ] Testnet deployment and testing
- [ ] Mainnet deployment
- [ ] Monitoring and analytics
- [ ] Documentation and user guides

## Contributing

Contributions are welcome! Please follow these guidelines:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Contribution Guidelines

- Follow Solidity style guide
- Add comprehensive tests for new features
- Update documentation
- Ensure all tests pass
- Address security considerations

## Testing

```bash
# Run all tests
npx hardhat test

# Run specific test file
npx hardhat test test/FuturesMarginPool.test.js

# Run tests with coverage
npx hardhat coverage

# Run tests with gas reporting
REPORT_GAS=true npx hardhat test
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2025 KuantLabs

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
```

## Disclaimer

This software is provided "as is", without warranty of any kind, express or implied. The developers and contributors are not responsible for any losses or damages resulting from the use of this software.

**IMPORTANT SECURITY NOTICE:** This contract contains known security vulnerabilities. Do NOT deploy to production or use with real funds until all security issues have been addressed and a professional audit has been completed.

## Contact & Support

- **GitHub**: [https://github.com/hugekuant/kuant](https://github.com/hugekuant/kuant)
- **Issues**: [https://github.com/hugekuant/kuant/issues](https://github.com/hugekuant/kuant/issues)
- **Website**: TBD
- **Documentation**: TBD

## Acknowledgments

- OpenZeppelin for secure smart contract libraries
- Hardhat team for excellent development tools
- LayerZero for cross-chain messaging infrastructure
- Aave for DeFi protocol integration
- Stargate Finance for cross-chain bridge technology

---

**Built with ❤️ by KuantLabs**
