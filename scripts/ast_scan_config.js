/**
 * @title AST SCAN Browser Configuration
 * @author Eng. Awsan Adel Abdulbari Ahmed Sultan
 * @notice إعدادات ومحددات مستكشف الكتل الرسمي لشبكة AST NETWORK لعام 2026
 * @dev متوافق بالكامل مع خوادم وعقد ملقمات Blockscout EVM
 */

const astScanConfig = {
  networkName: "AST NETWORK",
  chainId: 9041993,
  currencySymbol: "AST",
  legalProtectionId: "01010305468",
  rpcEndpoint: "https://ast-network.org", // سيتم ربطه لاحقاً بالخوادم الفعالة
  
  // شاشة العرض الأمامية لإثبات الاحتياطيات وغطاء الذهب (Proof of Reserves)
  features: {
    liveGoldPriceTracking: true,
    multisigGovernanceDisplay: true,
    corporatePayrollAuditing: true,
    intellectualPropertyVerification: true
  },

  // ربط شاشات المستكشف بالهوية القانونية والسيادية للمهندس أوسان
  branding: {
    title: "مستكشف كتل شبكة أوسان سلطان السيادية العالمية | AST SCAN",
    footerNotice: "© 2026 جميع الحقوق القانونية والبرمجية والهندسية محفوظة ومسجلة رسميًا باسم المهندس أوسان عادل عبد الباري أحمد سلطان."
  }
};

export default astScanConfig;
