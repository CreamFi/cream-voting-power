import "@nomiclabs/hardhat-waffle";

export default {
  defaultNetwork: "hardhat",
  solidity: {
    version: "0.8.6" ,
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  networks: {
    hardhat: {
      forking: {
        url: "https://mainnet-eth.compound.finance/",
        blockNumber: 12985524
      }
    }
  },
  mocha: {
    timeout: 600000
  }
};
