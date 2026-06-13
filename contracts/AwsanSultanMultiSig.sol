// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

/**
 * @title Awsan Sultan Multi-Sig Vault Wallet
 * @author Eng. Awsan Adel Abdulbari Ahmed Sultan
 * @notice المحفظة السيادية متعددة التوقيع الحاكمة لنظام الـ PoA والخزائن لعام 2026
 * @dev تتطلب توقيعين من أصل ثلاثة (2-of-3) لاعتماد وسحب أي مبالغ أو قرارات استراتيجية
 */
contract AwsanSultanMultiSig {

    address[] public owners;
    mapping(address => bool) public isOwner;
    uint256 public constant REQUIRED_SIGNATURES = 2;

    struct Transaction {
        address destination;
        uint256 value;
        bytes data;
        bool executed;
        uint256 signatureCount;
    }

    Transaction[] public transactions;
    mapping(uint256 => mapping(address => bool)) public confirmations;

    event Submission(uint256 indexed transactionId);
    event Confirmation(address indexed sender, uint256 indexed transactionId);
    event Execution(uint256 indexed transactionId);

    modifier onlyOwner() {
        require(isOwner[msg.sender], "Error: Not an authorized sovereign owner");
        _;
    }

    // تعيين المحافظ الثلاثة الحاكمة للمهندس أوسان عند التأسيس
    constructor(address[] memory _owners) {
        require(_owners.length == 3, "Error: Must exactly provide 3 sovereign owner keys");
        for (uint256 i = 0; i < _owners.length; i++) {
            address owner = _owners[i];
            require(owner != address(0), "Invalid owner address");
            require(!isOwner[owner], "Owner address must be unique");
            isOwner[owner] = true;
            owners.push(owner);
        }
    }

    /**
     * @notice اقتراح معاملة جديدة (مثل سحب مخصصات لتمويل مشروع عقاري أو شراء ذهب PAXG)
     */
    function submitTransaction(address destination, uint256 value, bytes calldata data) external onlyOwner returns (uint256 transactionId) {
        transactionId = transactions.length;
        transactions.push(Transaction({
            destination: destination,
            value: value,
            data: data,
            executed: false,
            signatureCount: 0
        }));
        emit Submission(transactionId);
        confirmTransaction(transactionId);
    }

    /**
     * @notice قيام المالك الثاني أو الثالث بتأكيد وتوقيع المعاملة رقمياً
     */
    function confirmTransaction(uint256 transactionId) public onlyOwner {
        require(transactionId < transactions.length, "Transaction does not exist");
        require(!confirmations[transactionId][msg.sender], "Transaction already confirmed by this key");
        
        confirmations[transactionId][msg.sender] = true;
        transactions[transactionId].signatureCount++;
        emit Confirmation(msg.sender, transactionId);
        
        // إذا اكتمل النصاب القانوني (توقيعين) يتم تنفيذ الأمر فوراً وتلقائياً على البلوكتشين
        if (transactions[transactionId].signatureCount >= REQUIRED_SIGNATURES && !transactions[transactionId].executed) {
            executeTransaction(transactionId);
        }
    }

    /**
     * @dev التنفيذ البرمجي الفعلي للمعاملة المعتمدة
     */
    function executeTransaction(uint256 transactionId) internal {
        Transaction storage txn = transactions[transactionId];
        require(!txn.executed, "Transaction already executed");
        require(txn.signatureCount >= REQUIRED_SIGNATURES, "Insufficient signatures gathered");

        txn.executed = true;
        (bool success, ) = txn.destination.call{value: txn.value}(txn.data);
        require(success, "Transaction execution failed on the network");
        
        emit Execution(transactionId);
    }

    // دوال مساعدة لقراءة البيانات
    function getOwners() external view returns (address[] memory) { return owners; }
    function getTransactionCount() external view returns (uint256) { return transactions.length; }
}
