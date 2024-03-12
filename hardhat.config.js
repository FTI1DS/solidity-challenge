require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.24",
  networks: {
    sepolia: {
      url: process.env.SEPOLIA_RPC_URL, // Die Umgebungsvariable, die Ihre Sepolia URL enthält
      accounts: [process.env.PRIVATE_KEY] // Ihr privater Schlüssel für das Deployen von Verträgen
    },
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY, // Ihr API-Schlüssel für Etherscan, der für die Verifizierung von Verträgen verwendet wird
  },
};
