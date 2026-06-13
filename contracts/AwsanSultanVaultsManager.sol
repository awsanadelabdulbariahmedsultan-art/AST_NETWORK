// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title Awsan Sultan Vaults Manager (AST Treasury)
 * @author Eng. Awsan Adel Abdulbari Ahmed Sultan
 * @notice إدارة وتأمين الخزائن الأربعة المضمونة بالأصول لشبكة AST NETWORK لعام 2026
 * @dev جميع الصلاحيات حصرية ومقيدة بالمحفظة متعددة التوقيع (Multisig Wallet)
 */
contract AwsanSultanVaultsManager is Ownable {
    
    IERC20 public immutable astToken;
    address public immutable multisigAdmin;

    // بنية بيانات الخزينة الذكية
    struct Vault {
        string name;         // اسم الخزينة
        uint256 totalAllocated; // إجمالي الحصة الأساسية المقفلة
        uint256 amountWithdrawn; // الكمية التي تم سحبها لدعم المشاريع والسيولة
        uint256 startReleaseTime; // وقت بدء فك الحظر
        uint256 releaseDuration;  // المدة الإجمالية للفك التدريجي
    }

    // تعريف الخزائن الأربعة برمجياً
    mapping(uint256 => Vault) public vaults;
    
    // قيم ثابتة لتعريف الخزائن
    uint256 public constant LIQUIDITY_VAULT = 1;  // 40% سيولة ومقاصة
    uint256 public constant ASSET_VAULT = 2;      // 25% مشاريع واقعية وودائع
    uint256 public constant TRUST_VAULT = 3;      // 15% حصة المؤسس المهندس أوسان
    uint256 public constant ECOSYSTEM_VAULT = 4;  // 20% مجتمع وإنزال جوي

    event FundWithdrawn(uint256 indexed vaultId, address indexed to, uint256 amount);

    // ربط العقد بالعملة والمحفظة متعددة التوقيع (Multisig) كمشرف وحيد
    constructor(address _astToken, address _multisigAdmin) Ownable(_multisigAdmin) {
        require(_astToken != address(0), "Invalid token address");
        require(_multisigAdmin != address(0), "Invalid multisig address");
        
        astToken = IERC20(_astToken);
        multisigAdmin = _multisigAdmin;

        // 1. خزينة السيولة والمقاصة (40%): متاحة فوراً لدعم تداولات صفقات النفط والشركات
        vaults[LIQUIDITY_VAULT] = Vault("Liquidity & Clearing Vault", 3616797200 * 10**18, 0, block.timestamp, 0);

        // 2. خزينة الأصول والودائع (25%): يتم تحريرها تدريجياً لفتح مشاريع على مدار سنتين
        vaults[ASSET_VAULT] = Vault("Asset-Backed Development Vault", 2260498250 * 10**18, 0, block.timestamp, 730 days);

        // 3. خزينة الضمان والمؤسس (15%): حظر كامل 6 أشهر ثم فك 1% شهرياً على مدار سنتين لحماية السعر
        vaults[TRUST_VAULT] = Vault("Sovereign Trust Vault", 1356298950 * 10**18, 0, block.timestamp + 180 days, 730 days);

        // 4. خزينة المجتمع والإنزال الجوي (20%): تحرير تدريجي على مدار سنة لدعم الولاء والـ Staking
        vaults[ECOSYSTEM_VAULT] = Vault("Ecosystem & Airdrop Vault", 1808398600 * 10**18, 0, block.timestamp, 365 days);
    }

    /**
     * @notice دالة سحب السيولة التدريجية المسموح بها للمشاريع من الخزائن
     * @dev لا يتم تفعيلها إلا بأمر موقع ومصدق من محفظتك متعددة التوقيع (Multisig)
     */
    function withdrawFromVault(uint256 _vaultId, address _to, uint256 _amount) external onlyOwner {
        Vault storage vault = vaults[_vaultId];
        require(vault.totalAllocated > 0, "Vault does not exist");
        require(_to != address(0), "Invalid recipient");

        uint256 maxAllowed = calculateMaxAllowed(_vaultId);
        require(vault.amountWithdrawn + _amount <= maxAllowed, "Amount exceeds authorized unlocked vest");

        vault.amountWithdrawn += _amount;
        require(astToken.transfer(_to, _amount), "AST Transfer failed");

        emit FundWithdrawn(_vaultId, _to, _amount);
    }

    /**
     * @dev حساب الحد الأقصى للمبالغ المتحررة برمجياً بدقة الثانية بناءً على مرور الوقت
     */
    function calculateMaxAllowed(uint256 _vaultId) public view returns (uint256) {
        Vault memory vault = vaults[_vaultId];
        if (block.timestamp < vault.startReleaseTime) {
            return 0;
        }
        if (vault.releaseDuration == 0 || block.timestamp >= vault.startReleaseTime + vault.releaseDuration) {
            return vault.totalAllocated;
        }
        return (vault.totalAllocated * (block.timestamp - vault.startReleaseTime)) / vault.releaseDuration;
    }
}
