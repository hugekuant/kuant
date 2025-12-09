# Kuant - Futures Margin Pool

A decentralized futures trading margin management system built on **BNB Smart Chain (BSC)** and compatible with other EVM networks.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![BNB Chain](https://img.shields.io/badge/BNB%20Chain-Ready-yellow.svg)](https://www.bnbchain.org/)
[![Solidity](https://img.shields.io/badge/Solidity-0.6.12-blue.svg)](https://docs.soliditylang.org/)

## Technology Stack

- **Blockchain**: BNB Smart Chain (BSC) + EVM-compatible chains
- **Smart Contracts**: Solidity ^0.6.12 (upgrade to 0.8.20+ recommended)
- **Frontend**: Not yet implemented
- **Development**: Hardhat 2.26.3, OpenZeppelin libraries 3.4.1
- **Package Manager**: pnpm 10.8.0
- **Cross-chain**: LayerZero V2 (3.0.36), Stargate Finance (1.3.1)
- **DeFi Integration**: Aave V3 (v3.2.0)

## Supported Networks

- **BNB Smart Chain Mainnet** (Chain ID: 56)
- **BNB Smart Chain Testnet** (Chain ID: 97)
- **Ethereum Mainnet** (Chain ID: 1) - *Future support*
- **opBNB** - *Future support*

## Contract Addresses

| Network | FuturesMarginPoolClassics | Status |
|---------|---------------------------|--------|
| BNB Mainnet (56) | [`0xf6ae4e36a14da4be1988911d5e03544dc35dff3a`](https://bscscan.com/address/0xf6ae4e36a14da4be1988911d5e03544dc35dff3a) | ✅ Deployed |
| BNB Testnet (97) | TBD | Development phase |
| Ethereum Mainnet (1) | TBD | Planned |

**IMPORTANT:** This contract contains known security vulnerabilities. Please review the [Security Status](#security-status) section before interacting with this contract.

## Features

- **Low-cost margin deposits on BNB Chain** - Leverage BSC's low transaction fees for efficient margin management
- **ERC20 token support** - Accept any BEP20/ERC20 token as collateral for futures trading
- **Reentrancy protection** - Built-in security against reentrancy attacks using OpenZeppelin's ReentrancyGuard
- **Admin-controlled withdrawals** - Secure withdrawal processing with dual admin architecture
- **Fee collection mechanism** - Configurable fee structure for protocol sustainability
- **Cross-chain ready** - Integrated with LayerZero V2 and Stargate Finance for future multi-chain expansion
- **Gas-efficient design for BNB Smart Chain** - Optimized for BSC's network characteristics

## BNB Chain Integration

### Why BNB Smart Chain?

Kuant is specifically designed for **BNB Smart Chain** due to:

1. **Low Transaction Costs**: BSC's gas fees are significantly lower than Ethereum, making frequent margin deposits/withdrawals economically viable
2. **Fast Block Times**: ~3 second block times enable quick confirmation of margin operations
3. **EVM Compatibility**: Seamless deployment using Solidity and Hardhat tooling
4. **Large DeFi Ecosystem**: Integration with BSC's thriving DeFi protocols (Aave, Stargate)
5. **BNB Token Liquidity**: Native support for BNB and BEP20 tokens as margin collateral

### BSC-Specific Configuration

The project is configured specifically for BNB Chain deployment:

**hardhat.config.js:**
```javascript
networks: {
  bsc: {
    url: process.env.BSC_RPC_URL,           // BSC Mainnet RPC
    accounts: [PRIVATE_KEY],
    chainId: 56
  },
  bscTestnet: {
    url: process.env.BSC_TESTNET_RPC_URL,   // BSC Testnet RPC
    accounts: [PRIVATE_KEY],
    chainId: 97
  }
}
```

**Environment Variables for BSC:**
```bash
BSC_RPC_URL=https://bsc-dataseed.binance.org/
BSC_TESTNET_RPC_URL=https://data-seed-prebsc-1-s1.binance.org:8545/
```

### BSC Deployment Commands

```bash
# Deploy to BSC Testnet
npx hardhat run scripts/deploy.js --network bscTestnet

# Deploy to BSC Mainnet
npx hardhat run scripts/deploy.js --network bsc

# Verify contract on BSCScan
npx hardhat verify --network bsc DEPLOYED_CONTRACT_ADDRESS
```

## Architecture

### FuturesMarginPoolClassics Contract

**Location:** `contracts/FuturesMarginPoolClassics.sol`

**Core Functionality:**
- Users deposit BEP20 tokens as margin collateral
- Off-chain futures trading engine manages positions
- Admin processes withdrawal requests with fee deduction
- All balances tracked on-chain for transparency

**Key Functions:**
- `deposit(uint256 depositAmount, bytes32 depositHash)` - User deposits margin tokens
- `withdraw(address account, uint256 withdrawAmount, uint256 fee, bytes32 withdrawHash)` - Admin processes withdrawals
- `getUserAddressBalance()` - Query user's deposit/withdrawal totals
- `withdrawAdminFun(uint256 withdrawAmount)` - Admin moves funds to vault

## Installation

### Prerequisites

- Node.js >= 16.x
- pnpm >= 10.8.0
- BNB Chain wallet with BNB for gas fees

### Setup

```bash
# Clone the repository
git clone https://github.com/hugekuant/kuant.git
cd kuant

# Install dependencies
pnpm install

# Create environment file
cp .env.example .env

# Configure BSC RPC endpoints
# Edit .env with your BSC configuration:
# PRIVATE_KEY=your_private_key_here
# BSC_RPC_URL=https://bsc-dataseed.binance.org/
# BSC_TESTNET_RPC_URL=https://data-seed-prebsc-1-s1.binance.org:8545/
```

### Compile Contracts

```bash
pnpm run compile
```

### Run Tests

```bash
# Note: Test suite not yet implemented
pnpm run test
```

## Security Status

### ⚠️ CRITICAL SECURITY NOTICE

**Status:** ❌ **NOT PRODUCTION READY**

This contract contains **10 critical vulnerabilities** and should **NOT** be deployed with real funds until all security issues are resolved.

**Security Score:** 2/10

**Critical Issues:**
- C-01: Unrestricted fund drainage via `withdrawAdminFun`
- C-02: No balance validation in withdrawal function
- C-03: Admin can change token address and steal funds
- C-04: Excessive fee extraction possible
- C-05: Single admin can change own address without safeguards
- C-06: Outdated Solidity version (0.6.12)
- C-07: No emergency pause mechanism
- C-08: Inconsistent balance accounting
- C-09: Missing access control events
- C-10: Complete trust in admins (centralization risk)

**Full Audit Report:** See [SECURITY_AUDIT_REPORT.md](./SECURITY_AUDIT_REPORT.md)

### Required Before Mainnet Deployment

- [ ] Address all critical vulnerabilities
- [ ] Upgrade to Solidity 0.8.20+
- [ ] Implement emergency pause mechanism
- [ ] Add comprehensive balance validation
- [ ] Implement multi-signature admin controls
- [ ] Complete test suite with 100% coverage
- [ ] Professional external security audit
- [ ] Extensive testnet deployment period (minimum 3 months)
- [ ] Bug bounty program

## BSC Deployment Checklist

Before deploying to BNB Smart Chain:

### Pre-Deployment
- [ ] All security vulnerabilities addressed
- [ ] Contract upgraded to Solidity 0.8.20+
- [ ] Comprehensive test suite completed
- [ ] External security audit passed
- [ ] Multi-sig wallets configured for admin roles
- [ ] BSC Testnet deployment successful
- [ ] Community testing period completed

### Deployment Configuration
- [ ] BSC RPC endpoints configured
- [ ] Private key secured (use hardware wallet)
- [ ] Gas price strategy optimized for BSC
- [ ] Deployment script tested
- [ ] Contract constructor parameters verified
- [ ] Initial margin token address set correctly

### Post-Deployment
- [ ] Contract verified on BSCScan
- [ ] Ownership transferred to multi-sig
- [ ] Monitoring and alerting configured
- [ ] Emergency procedures documented
- [ ] Community announcement prepared
- [ ] BSCScan contract metadata updated

## BNB Chain Resources

- **BSC Official Website**: https://www.bnbchain.org/
- **BSC Documentation**: https://docs.bnbchain.org/
- **BSCScan (Mainnet)**: https://bscscan.com/
- **BSCScan (Testnet)**: https://testnet.bscscan.com/
- **BSC Faucet**: https://testnet.bnbchain.org/faucet-smart
- **BSC RPC Endpoints**: https://docs.bnbchain.org/docs/rpc

## Gas Optimization for BSC

Kuant is designed with BSC's gas model in mind:

- Uses `SafeMath` for overflow protection (Solidity 0.6.12)
- `nonReentrant` guards only on critical functions
- Storage variables packed efficiently
- Event emissions for off-chain indexing
- Minimal on-chain computation

**Estimated Gas Costs on BSC:**
- Deposit: ~60,000 gas (~0.0012 BNB at 5 gwei)
- Withdrawal: ~80,000 gas (~0.0016 BNB at 5 gwei)

## Roadmap

### Phase 1: Security Hardening (Current - Q1 2025)
- [ ] Address all critical vulnerabilities
- [ ] Upgrade to Solidity 0.8.20+
- [ ] Implement pause mechanism
- [ ] Multi-signature admin controls

### Phase 2: BSC Testnet Deployment (Q2 2025)
- [ ] Comprehensive test suite
- [ ] Deploy to BSC Testnet (Chain ID: 97)
- [ ] Community testing program
- [ ] Bug bounty on testnet

### Phase 3: Security Audit (Q2-Q3 2025)
- [ ] Professional external audit
- [ ] Formal verification
- [ ] Penetration testing
- [ ] Code freeze period

### Phase 4: BSC Mainnet Launch (Q3-Q4 2025)
- [ ] Deploy to BSC Mainnet (Chain ID: 56)
- [ ] Gradual rollout with deposit caps
- [ ] 24/7 monitoring
- [ ] Mainnet bug bounty program

### Phase 5: Multi-Chain Expansion (2026)
- [ ] opBNB integration
- [ ] Ethereum Layer 2 support
- [ ] LayerZero cross-chain features
- [ ] Greenfield storage integration

## Contributing

We welcome contributions from the BNB Chain community! Please follow these guidelines:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Ensure all tests pass
4. Address security considerations
5. Submit a pull request

**Security-First Development:**
- All PRs must pass security review
- New features require test coverage
- Follow Solidity best practices
- Document BNB Chain-specific considerations

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

```
MIT License
Copyright (c) 2025 KuantLabs
```

## Disclaimer

This software is provided "as is", without warranty of any kind. The developers are not responsible for any losses resulting from the use of this software.

**IMPORTANT:** This contract is currently in development and contains known security vulnerabilities. Do **NOT** deploy to BNB Chain mainnet or use with real funds until:
1. All security issues are resolved
2. Professional audit is completed
3. Extensive testing period is concluded
4. Official production-ready announcement is made

## Contact & Support

- **GitHub**: https://github.com/hugekuant/kuant
- **Issues**: https://github.com/hugekuant/kuant/issues
- **Security**: For security concerns, please email security@kuantlabs.io
- **BNB Chain Forum**: [Post your questions](https://forum.bnbchain.org/)

## BNB Chain Ecosystem Integration

Kuant is committed to being a valuable member of the BNB Chain ecosystem:

- **Primary Deployment Target**: BNB Smart Chain (BSC)
- **BSC-Optimized**: Designed for BSC's gas model and network characteristics
- **BEP20 Compatible**: Full support for BNB Chain token standards
- **Future Integration**: Plans for opBNB and Greenfield
- **Community Focused**: Building for BNB Chain users and developers

## Acknowledgments

- **BNB Chain Foundation** for the robust blockchain infrastructure
- **OpenZeppelin** for secure smart contract libraries
- **Hardhat** for development tools
- **LayerZero** for cross-chain capabilities
- **Stargate Finance** for cross-chain bridge technology
- **Aave** for DeFi protocol integration

---

**Built with ❤️ for the BNB Chain Ecosystem by KuantLabs**

*Leveraging BNB Smart Chain's speed, cost-efficiency, and vibrant DeFi ecosystem to revolutionize futures trading margin management.*
