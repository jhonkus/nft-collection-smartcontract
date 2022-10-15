// require("@nomicfoundation/hardhat-toolbox");

require('@nomiclabs/hardhat-waffle');
require('dotenv').config();

module.exports = {
  solidity: '0.8.17',
  networks: {
    goerli: {
      url: process.env.INFURA_KEY,
      accounts: [process.env.PRIVATE_KEY],
    },
    sepolia: {
      url: process.env.INFURA_KEY,
      accounts: [process.env.PRIVATE_KEY],
    },
    mainnet: {
      chainId: 1,
      url: process.env.PROD_QUICKNODE_KEY,
      accounts: [process.env.PRIVATE_KEY],
    },
  },
};
