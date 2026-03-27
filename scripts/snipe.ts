import { ethers } from "hardhat";

async function main() {
  const SNIPER_CONTRACT_ADDRESS = process.env.SNIPER_ADDRESS as string;
  const TARGET_ADDRESS = process.env.TARGET_ADDRESS as string;
  const ETH_TO_SPEND = ethers.parseEther(process.env.ETH_AMOUNT || "0.01");

  const sniper = await ethers.getContractAt("BaseSniper", SNIPER_CONTRACT_ADDRESS);

  const iface = new ethers.Interface(["function buyTokens()"]);
  const payload = iface.encodeFunctionData("buyTokens", []);

  const tx = await sniper.snipe(
    TARGET_ADDRESS,
    payload,
    ETH_TO_SPEND,
    {
      gasLimit: 300000,
      maxFeePerGas: ethers.parseUnits("5", "gwei"),
      maxPriorityFeePerGas: ethers.parseUnits("2", "gwei")
    }
  );

  console.log(`Transaction sent: ${tx.hash}`);
  
  const receipt = await tx.wait();
  console.log(`Snipe executed in block: ${receipt?.blockNumber}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
