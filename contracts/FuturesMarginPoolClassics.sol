// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Address.sol";

contract FuturesMarginPoolClassics is ReentrancyGuard {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    address public marginCoinAddress;

    address private withdrawAdmin;

    address private vaults;

    address private feeAddress;

    address private admin;

    struct UserAsset {
        uint256 inAmount;
        uint256 outAmount;
    }

    mapping(address => UserAsset) private userAssetInfo;

    mapping(bytes32 => uint) private withdrawFlag;

    modifier onlyAdmin() {
        require(msg.sender == admin, "Call: OnlyAdmin");
        _;
    }

    modifier onlyWithdrawAdmin() {
        require(msg.sender == withdrawAdmin, "Call: OnlyWithdrawAdmin");
        _;
    }

    event FuturesMarginDeposit(bytes32 recordHash, address account, uint256 amount);

    event FuturesMarginWithdraw(bytes32 recordHash, address account, uint256 amount, uint256 fee);

    constructor(
        address _withdrawAdmin,
        address _admin,
        address _vaults,
        address _feeAddress,
        address _marginCoinAddress
    ) public {
        require(
            _withdrawAdmin != address(0) && _admin != address(0) && _vaults != address(0)
                && _feeAddress != address(0) && _marginCoinAddress != address(0),
            "FuturesMarginPool/INIT_PARAMS_ERROR"
        );
        withdrawAdmin = _withdrawAdmin;
        admin = _admin;
        vaults = _vaults;
        feeAddress = _feeAddress;
        marginCoinAddress = _marginCoinAddress;
    }

    function deposit(uint256 depositAmount, bytes32 depositHash) public nonReentrant {
        IERC20(marginCoinAddress).safeTransferFrom(msg.sender, address(this), depositAmount);

        emit FuturesMarginDeposit(depositHash, msg.sender, depositAmount);

        userAssetInfo[msg.sender].inAmount = userAssetInfo[msg.sender].inAmount.add(depositAmount);
    }

    function withdraw(address account, uint256 withdrawAmount, uint256 fee, bytes32 withdrawHash)
        public nonReentrant onlyWithdrawAdmin returns (uint)
    {
        if (withdrawFlag[withdrawHash] != 1) {
            IERC20(marginCoinAddress).safeTransfer(account, withdrawAmount.sub(fee));

            IERC20(marginCoinAddress).safeTransfer(feeAddress, fee);

            emit FuturesMarginWithdraw(withdrawHash, account, withdrawAmount, fee);

            userAssetInfo[account].outAmount = userAssetInfo[account].outAmount.add(withdrawAmount);

            withdrawFlag[withdrawHash] = 1;

            return 1;
        } else {
            return 0;
        }
    }

    function withdrawAdminFun(uint256 withdrawAmount) public onlyAdmin {
        IERC20(marginCoinAddress).safeTransfer(vaults, withdrawAmount);
    }

    function modifyMarginAddress(address _marginCoinAddress) public onlyAdmin {
        require(_marginCoinAddress != address(0), "FuturesMarginPool/MARGIN_COIN_ERROR");
        marginCoinAddress = _marginCoinAddress;
    }

    function modifyWithdrawAdmin(address _withdrawAdmin) public onlyAdmin {
        require(_withdrawAdmin != address(0), "FuturesMarginPool/WITHDRAW_ADMIN_ERROR");
        withdrawAdmin = _withdrawAdmin;
    }

    function modifyVaultsAddress(address _vaults) public onlyAdmin {
        require(_vaults != address(0), "FuturesMarginPool/VAULTS_ERROR");
        vaults = _vaults;
    }

    function modifyFeeAddress(address _feeAddress) public onlyAdmin {
        require(_feeAddress != address(0), "FuturesMarginPool/FEE_ADDRESS_ERROR");
        feeAddress = _feeAddress;
    }

    function modifyAdmin(address _admin) public onlyAdmin {
        require(_admin != address(0), "FuturesMarginPool/ADMIN_ERROR");
        admin = _admin;
    }

    function getUserAddressBalance() public view returns (uint256, uint256) {
        return (userAssetInfo[msg.sender].inAmount , userAssetInfo[msg.sender].outAmount);
    }

    function getWithdrawStatus(bytes32 withdrawHash) public view returns (uint) {
        return withdrawFlag[withdrawHash];
    }

    function adminAddress() public view returns (address) {
        return admin;
    }

    function vaultsAddress() public view returns (address) {
        return vaults;
    }

    function getFeeAddress() public view returns (address) {
        return feeAddress;
    }

    function withdrawAdminAddress() public view returns (address) {
        return withdrawAdmin;
    }
}