require("@nomicfoundation/hardhat-toolbox");
require('@openzeppelin/hardhat-upgrades');
require('dotenv').config()
const fs = require('fs');

const PRIVATE_KEY = process.env.PRIVATE_KEY;


/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.6.12",
  
  networks: {
    hardhat: {
      chainId: 1337,
      loggingEnabled: true,
      // 不指定accounts，让hardhat使用默认的20个测试账户
    },
    bsc: {
      url: process.env.BSC_RPC_URL,
      accounts: [PRIVATE_KEY],
    },
    bscTestnet: {
      url: process.env.BSC_TESTNET_RPC_URL,
      accounts: [PRIVATE_KEY],
    },
  },
  contractSizer: {
    alphaSort: true,
    disambiguatePaths: false,
    runOnCompile: true,
    strict: false,
    only: []
  },
  etherscan:{
    apiKey: {
      bsc: "",
      polygon: ""
    }
  },
};
