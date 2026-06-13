// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title Awsan Sultan International Treasury & Vesting Guard
 * @author Eng. Awsan Adel Abdulbari Ahmed Sultan
 * @notice حظر وحصر وحماية معروض شبكة AST NETWORK لمنع الانهيار والبيع الجماعي لعام 2026
 * @dev مسجل رسميًا برقم قيد الحماية الملكية الفكرية: 01010305468 / YEMEN
 */
contract AwsanSultanTreasury is Ownable {

    IERC20 public immutable astToken;
    address public immutable multisigAdmin;

    struct Vault {
        string name;
        uint256 totalAllocated;
        uint256 amountWithdrawn;
        uint256 startReleaseTime;
        uint256 releaseDuration;
    }

    mapping(uint256 => Vault) public pools;

    // محددات الصناديق والخزائن الأربعة المستقرة (40%)
    uint256 public constant ECOSYSTEM_POOL = 1; // 20% حوافز ومكافآت مجتمع وإنزال جوي
    uint256 public constant SOVEREIGN_POOL = 2; // 15% حصة المؤسس المهندس أوسان (حظر كامل 6 أشهر)
    uint256 public constant EMERGENCY_POOL = 3; // 5% احتياطي أمان السيولة وأوراكل الذهب

    // سجل حماية جدران المستثمرين الأوائل لمنع تسونامي البيع الجماعي (Seed Vesting)
    struct InvestorVesting {
        uint256 totalPurchased;
        uint256 totalClaimed;
        uint256 startVestingTime;
        uint256 vestingDuration;
    }
    mapping(address => InvestorVesting) public seedInvestors;

    event FundReleased(uint256 indexed poolId, address indexed to, uint256 amount);
    event InvestorTokensRegistered(address indexed investor, uint256 amount);
    event InvestorTokensClaimed(address indexed investor, uint256 amount);

    constructor(address _astToken, address _multisigAdmin) Ownable(_multisigAdmin) {
        require(_astToken != address(0) && _multisigAdmin != address(0), "Invalid Addresses");
        astToken = IERC20(_astToken);
        multisigAdmin = _multisigAdmin;

        // 1. خزينة المجتمع (20%): تحرير تدريجي على مدار سنة للإنزال الجوي والـ Staking
        pools[ECOSYSTEM_POOL] = Vault("Ecosystem & Airdrop Vault", 1808398600 * 10**18, 0, block.timestamp, 365 days);

        // 2. خزينة المؤسس (15%): قفل وحظر مطلق 6 أشهر ثم فك تدريجي على سنتين حماية للسعر
        pools[SOVEREIGN_POOL] = Vault("Sovereign Trust Vault", 1356298950 * 10**18, 0, block.timestamp + 180 days, 730 days);

        // 3. خزينة احتياطي الطوارئ (5%): متاحة فوراً للمقاصة البنكية ودعم الأوراكل والذهب
        pools[EMERGENCY_POOL] = Vault("Emergency Liquidity Guard", 452099650 * 10**18, 0, block.timestamp, 0);
    }

    /**
     * @notice تسجيل كبار ومستثمري الجولة الأولى برمجياً وفرض جدار الحظر عليهم
     * @dev لا يتم تفعيلها إلا بتوقيع معتمد من محفظتك متعددة التوقيع (Multisig Wallet)
     */
    function registerSeedInvestor(address _investor, uint256 _amount) external onlyOwner {
        require(_investor != address(0) && _amount > 0, "Invalid investor data");
        require(seedInvestors[_investor].totalPurchased == 0, "Investor already registered");

        // فرض حظر كلي لـ 6 أشهر، ثم فك تدريجي ذكي لمنع الإغراق والبيع الجماعي
        seedInvestors[_investor] = InvestorVesting({
            totalPurchased: _amount,
            totalClaimed: 0,
            startVestingTime: block.timestamp + 180 days,
            vestingDuration: 365 days
        });

        emit InvestorTokensRegistered(_investor, _amount);
    }

    /**
     * @notice دالة سحب وتسييل العملات التدريجية للمستثمر بناءً على مرور الوقت بعد انتهاء الحظر
     */
    function claimInvestorTokens() external {
        InvestorVesting storage investor = seedInvestors[msg.sender];
        require(investor.totalPurchased > 0, "Not a registered seed investor");
        require(block.timestamp >= investor.startVestingTime, "Tokens are strictly locked under protection period");

        uint256 claimable = calculateClaimable(msg.sender);
        uint256 currentAllowed = claimable - investor.totalClaimed;
        require(currentAllowed > 0, "No unlocked tokens available for claim at this second");

        investor.totalClaimed += currentAllowed;
        require(astToken.transfer(msg.sender, currentAllowed), "AST Transfer Failed");

        emit InvestorTokensClaimed(msg.sender, currentAllowed);
    }

    function calculateClaimable(address _investor) public view returns (uint256) {
        InvestorVesting memory investor = seedInvestors[_investor];
        if (block.timestamp < investor.startVestingTime) return 0;
        if (block.timestamp >= investor.startVestingTime + investor.vestingDuration) return investor.totalPurchased;
        return (investor.totalPurchased * (block.timestamp - investor.startVestingTime)) / investor.vestingDuration;
    }
}
