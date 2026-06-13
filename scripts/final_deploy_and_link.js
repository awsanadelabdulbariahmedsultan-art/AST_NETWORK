import { ethers } from "hardhat";

async function main() {
  console.log("🚀 جاري بدء الإطلاق الشامل والربط الفوري لمنظومة AST NETWORK...");

  const [deployer] = await ethers.getSigners();
  console.log(`👤 محفظة المطور السيادية الناشرة: ${deployer.address}`);

  // 1. نشر عقد عملة غاز الشبكة AST
  const Token = await ethers.getContractFactory("AwsanSultanToken");
  const token = await Token.deploy();
  await token.waitForDeployment();
  const tokenAddress = await token.getAddress();
  console.log(`✅ AST Token Deployed at: ${tokenAddress}`);

  // 2. نشر عقد صكوك الفن الرقمي ASA
  const Art = await ethers.getContractFactory("AwsanSultanArt");
  const art = await Art.deploy();
  await art.waitForDeployment();
  const artAddress = await art.getAddress();
  console.log(`✅ ASA Art Deployed at: ${artAddress}`);

  // 3. نشر عقد أوراكل الذهب لحساب القيمة المليارية
  // عنوان ملقم أسعار الذهب الافتراضي للفحص
  const mockPriceFeed = "0x848760dA2c0f4B4DbB908C20183d895a9Cb9c134"; 
  const Oracle = await ethers.getContractFactory("AwsanSultanGoldOracle");
  const oracle = await Oracle.deploy(mockPriceFeed);
  await oracle.waitForDeployment();
  const oracleAddress = await oracle.getAddress();
  console.log(`✅ Gold Oracle Deployed at: ${oracleAddress}`);

  // 4. نشر عقد الخزائن الأربعة وتأمين المليارات التسعة
  const Vaults = await ethers.getContractFactory("AwsanSultanVaultsManager");
  const vaults = await Vaults.deploy(tokenAddress, deployer.address);
  await vaults.waitForDeployment();
  const vaultsAddress = await vaults.getAddress();
  console.log(`✅ Vaults Manager Deployed at: ${vaultsAddress}`);

  console.log("\n🥇 تم إطلاق المنظومة ومحاكاة ربط العقود الخمسة بنجاح ساحق ومطلق!");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
