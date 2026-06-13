import { ethers } from "hardhat";

async function main() {
  console.log("🚀 جاري التحضير لبث محفظة الـ Multi-Sig السيادية...");

  // 🔒 ضع عناوين محافظ التوقيع الثلاثة الخاصة بك هنا بدقة بالغة
  const owner1 = "0x848760dA2c0f4B4DbB908C20183d895a9Cb9c134"; // محفظتك الحالية في ميتاماسك
  const owner2 = "0x79Fd74aE9cD16838fD2bf61274CDa5c37dA1f714"; // المحفظة الثانية (النسخة الاحتياطية)
  const owner3 = "0xd81422ff3d1d11d8f01924639569a14a3aa70777"; // المحفظة الثالثة (خزينة الأصول أو الحماية)

  const ownersArray = [owner1, owner2, owner3];

  const MultiSig = await ethers.getContractFactory("AwsanSultanMultiSig");
  const multisig = await MultiSig.deploy(ownersArray);
  await multisig.waitForDeployment();

  console.log(`✅ تم نشر وتفعيل محفظة الـ Multi-Sig بنجاح على العنوان: ${await multisig.getAddress()}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
