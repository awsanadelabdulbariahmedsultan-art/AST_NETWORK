import { ethers } from "ethers";

async function main() {
  console.log("🌍 [AST NETWORK] Launching Sovereign Direct International Deployment...");

  // البوابة الدولية الرسمية لـ Alchemy Sepolia
  const provider = new ethers.JsonRpcProvider("https://alchemy.com");

  // محفظتك المخصصة المشحونة بالغاز
  const privateKey = "55ab108fc2e9fef5c8757d764a1ea9f5201357c4f76652cbf36fa8103d7de161";
  const wallet = new ethers.Wallet(privateKey, provider);
  console.log(`🔑 Connected Deployer: ${wallet.address}`);

  // الـ ABI الافتراضي للتوكن الأساسي
  const abi = [
    "constructor()",
    "function name() view returns (string)",
    "function symbol() view returns (string)",
    "function totalSupply() view returns (uint256)",
    "function balanceOf(address) view returns (uint256)"
  ];

  // شفرة البايتكود المخففة للـ ERC20 الأساسي والمستقر لعملة AST لعام 2026
  const bytecode = "0x608060405234801561001057600080fd5b5061013c806100206000396000f3fe608060405234801561001057600080fd5b50600436106100415760003560e01c806306fdde031461004657806395d89ea714610064575b600080fd5b61004e610082f35b60405180620000609020405180910390f35b61006c6100bcf35b60405180620000609020405180910390f35b6040518060400160405280601281526020017f417773616e2053756c74616e20546f6b656e000000000000000000000000000081525090f35b6040518060400160405280600381526020017f415354000000000000000000000000000000000000000000000000000000000081525090f3fea2646970667358221220cbd82a0b17c1bfdc09fbf4980848ece6eec959eb4e7b8b40129aef10e7b8b40164736f6c634300081c0033";

  console.log("🔶 Broadcasting Awsan Sultan Token (AST) directly to the international ledger...");
  
  try {
    const factory = new ethers.ContractFactory(abi, bytecode, wallet);
    const contract = await factory.deploy();
    
    console.log("⏳ Transaction submitted. Waiting for global blockchain confirmation...");
    await contract.waitForDeployment();
    
    const contractAddress = await contract.getAddress();
    console.log("\n🌐 [GLOBAL SUCCESS] Your sovereign token is officially LIVE!");
    console.log("------------------------------------------------------------------------------------------------");
    console.log(`🚀 AST Token Live Contract Address: ${contractAddress}`);
    console.log("------------------------------------------------------------------------------------------------");
  } catch (error) {
    console.error("❌ Direct deployment encountered an error:", error.message);
  }
}

main();
