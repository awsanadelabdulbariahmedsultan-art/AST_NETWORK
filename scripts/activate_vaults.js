import { ethers } from "hardhat";

async function main() {
  console.log("🚀 جاري تفعيل الخزائن الأربعة وتوزيع المليارات التسعة لـ AST NETWORK...");

  // استخراج الحسابات
  const [deployer] = await ethers.getSigners();
  console.log(`👤 محفظة المطور السيادية الناشرة: ${deployer.address}`);

  // جلب العقود
  const Token = await ethers.getContractFactory("AwsanSultanToken");
  const token = await Token.deploy();
  await token.waitForDeployment();
  const tokenAddress = await token.getAddress();
  console.log(`✅ تم بث عملة AST بنجاح على العنوان: ${tokenAddress}`);

  const VaultsManager = await ethers.getContractFactory("AwsanSultanVaultsManager");
  // افترضنا عنوان محفظة الـ Multisig الحاكمة هو نفسه الناشر لأغراض المحاكاة السريعة الحالية
  const vaults = await VaultsManager.deploy(tokenAddress, deployer.address);
  await vaults.waitForDeployment();
  const vaultsAddress = await vaults.getAddress();
  console.log(`✅ تم ربط وتفعيل الخزائن الأربعة بنجاح على العنوان: ${vaultsAddress}`);

  console.log("🥇 منظومة أوسان سلطان السيادية جاهزة الآن بالكامل ومحصنة بالذهب!");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
