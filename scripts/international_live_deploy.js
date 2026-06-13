import { ethers } from "hardhat";

async function main() {
  console.log("🌍 [AST NETWORK] Starting International Live Blockchain Deployment...");

  // استخراج المحفظة السيادية الناشرة المربوطة بملف الإعدادات
  const [deployer] = await ethers.getSigners();
  console.log(`🔑 Sovereign Deployer Address: ${deployer.address}`);

  // 1. بث عقد عملة غاز الشبكة والمقاصة الدولية AST
  console.log("🔶 Broadcasting Awsan Sultan Token (AST) to the global ledger...");
  const Token = await ethers.getContractFactory("AwsanSultanToken");
  const token = await Token.deploy();
  await token.waitForDeployment();
  const tokenAddress = await token.getAddress();
  console.log(`✅ AST Token LIVE at address: ${tokenAddress}`);

  // 2. بث عقد صكوك الملكية الفكرية وعوائد الـ 10% التلقائية ASA
  console.log("🎨 Broadcasting Awsan Sultan Art (ASA) global certifications...");
  const Art = await ethers.getContractFactory("AwsanSultanArt");
  const art = await Art.deploy();
  await art.waitForDeployment();
  const artAddress = await art.getAddress();
  console.log(`✅ ASA Art LIVE at address: ${artAddress}`);

  // 3. بث عقد ملقم أسعار المقاصة وأوراكل الذهب لـ Chainlink
  console.log("🪙 Broadcasting Awsan Sultan Gold Oracle (Chainlink Matrix)...");
  // عنوان ملقم أسعار الذهب العالمي الرسمي (XAU/USD Chainlink Feed)
  const officialGoldFeed = "0xC5981F4635b7D9A2c3217293605490f889C215f8"; 
  const Oracle = await ethers.getContractFactory("AwsanSultanGoldOracle");
  const oracle = await Oracle.deploy(officialGoldFeed);
  await oracle.waitForDeployment();
  const oracleAddress = await oracle.getAddress();
  console.log(`✅ Gold Oracle LIVE at address: ${oracleAddress}`);

  // 4. بث عقد الخزائن الأربعة الذكية لحظر وحصر وإدارة المليارات التسعة
  console.log("🔒 Broadcasting Awsan Sultan Vaults Manager (Treasury Pools)...");
  const Vaults = await ethers.getContractFactory("AwsanSultanVaultsManager");
  const vaults = await Vaults.deploy(tokenAddress, deployer.address);
  await vaults.waitForDeployment();
  const vaultsAddress = await vaults.getAddress();
  console.log(`✅ Vaults Manager LIVE at address: ${vaultsAddress}`);

  console.log("\n🌐 [SUCCESS] All sovereign contracts are now officially LIVE on the international blockchain infrastructure!");
  console.log("------------------------------------------------------------------------------------------------");
  console.log(`AST Token Address:    ${tokenAddress}`);
  console.log(`ASA Art Address:      ${artAddress}`);
  console.log(`Gold Oracle Address:  ${oracleAddress}`);
  console.log(`Vaults Vault Address: ${vaultsAddress}`);
  console.log("------------------------------------------------------------------------------------------------");
}

main().catch((error) => {
  console.error("❌ International deployment failed:");
  console.error(error);
  process.exitCode = 1;
});
