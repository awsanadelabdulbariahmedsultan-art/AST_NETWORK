import fs from "fs";
import { ethers } from "ethers";

async function main() {
  console.log("🌍 [AST NETWORK] Starting Pure International Live Deployment...");

  // ربط البوابة الدولية الرسمية لـ Alchemy Sepolia
  const provider = new ethers.JsonRpcProvider("https://alchemy.com");

  // حقن محفظتك ومفتاحك المطور المشحون بالغاز بدقة وأمان
  const privateKey = "55ab108fc2e9fef5c8757d764a1ea9f5201357c4f76652cbf36fa8103d7de161";
  const wallet = new ethers.Wallet(privateKey, provider);
  console.log(`🔑 Secure Sovereign Deployer Address: ${wallet.address}`);

  // قراءة ملفات الكومبايل الجاهزة الناجحة التي قمنا بها سابقاً
  const tokenArtifact = JSON.parse(fs.readFileSync("./artifacts/contracts/AwsanSultanToken.sol/AwsanSultanToken.json", "utf8"));
  const artArtifact = JSON.parse(fs.readFileSync("./artifacts/contracts/AwsanSultanArt.sol/AwsanSultanArt.json", "utf8"));
  const oracleArtifact = JSON.parse(fs.readFileSync("./artifacts/contracts/AwsanSultanGoldOracle.sol/AwsanSultanGoldOracle.json", "utf8"));
  const vaultsArtifact = JSON.parse(fs.readFileSync("./artifacts/contracts/AwsanSultanVaultsManager.sol/AwsanSultanVaultsManager.json", "utf8"));

  // 1. بث عملة غاز الشبكة والمقاصة الدولية AST
  console.log("🔶 Broadcasting Awsan Sultan Token (AST)...");
  const tokenFactory = new ethers.ContractFactory(tokenArtifact.abi, tokenArtifact.bytecode, wallet);
  const token = await tokenFactory.deploy();
  await token.waitForDeployment();
  const tokenAddress = await token.getAddress();
  console.log(`✅ AST Token LIVE at address: ${tokenAddress}`);

  // 2. بث صكوك الملكية الفكرية وعوائد الـ 10% التلقائية ASA
  console.log("🎨 Broadcasting Awsan Sultan Art (ASA)...");
  const artFactory = new ethers.ContractFactory(artArtifact.abi, artArtifact.bytecode, wallet);
  const art = await artFactory.deploy();
  await art.waitForDeployment();
  const artAddress = await art.getAddress();
  console.log(`✅ ASA Art LIVE at address: ${artAddress}`);

  // 3. بث عقد ملقم أسعار المقاصة وأيراكل الذهب لـ Chainlink
  console.log("🪙 Broadcasting Awsan Sultan Gold Oracle...");
  const officialGoldFeed = "0xC5981F4635b7D9A2c3217293605490f889C215f8";
  const oracleFactory = new ethers.ContractFactory(oracleArtifact.abi, oracleArtifact.bytecode, wallet);
  const oracle = await oracleFactory.deploy(officialGoldFeed);
  await oracle.waitForDeployment();
  const oracleAddress = await oracle.getAddress();
  console.log(`✅ Gold Oracle LIVE at address: ${oracleAddress}`);

  // 4. بث عقد الخزائن الأربعة الذكية لحظر وحصر وإدارة المليارات التسعة
  console.log("🔒 Broadcasting Awsan Sultan Vaults Manager...");
  const vaultsFactory = new ethers.ContractFactory(vaultsArtifact.abi, vaultsArtifact.bytecode, wallet);
  const vaults = await vaultsFactory.deploy(tokenAddress, wallet.address);
  await vaults.waitForDeployment();
  const vaultsAddress = await vaults.getAddress();
  console.log(`✅ Vaults Manager LIVE at address: ${vaultsAddress}`);

  console.log("\n🌐 [GLOBAL SUCCESS] All contracts are now LIVE on the international blockchain infrastructure!");
  console.log("------------------------------------------------------------------------------------------------");
  console.log(`AST Token Address:    ${tokenAddress}`);
  console.log(`ASA Art Address:      ${artAddress}`);
  console.log(`Gold Oracle Address:  ${oracleAddress}`);
  console.log(`Vaults Vault Address: ${vaultsAddress}`);
  console.log("------------------------------------------------------------------------------------------------");
}

main().catch((error) => {
  console.error("❌ Pure deployment failed:", error);
});
