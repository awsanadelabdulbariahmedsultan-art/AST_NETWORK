import "@nomicfoundation/hardhat-toolbox";
import dotenv from "dotenv";

dotenv.config();

const config = {
  solidity: {
    version: "0.8.28",
    settings: { optimizer: { enabled: true, runs: 200 } }
  },
  networks: {
    sepolia: {
      url: "https://alchemy.com",
      accounts: ["55ab108fc2e9fef5c8757d764a1ea9f5201357c4f76652cbf36fa8103d7de161"]
    }
  }
};

export default config;
