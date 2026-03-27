import { ethers } from "hardhat";

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log(`Deploying BaseSniper with account: ${deployer.address}`);

  const SniperFactory = await ethers.getContractFactory("BaseSniper");
  const sniper = await SniperFactory.deploy();
  await sniper.waitForDeployment();

  const address = await sniper.getAddress();
  console.log(`BaseSniper deployed to: ${address}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
