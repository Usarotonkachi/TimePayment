pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TimePayment is Ownable {
    mapping(address => uint256) addressToAmount;
    //mapping(address => uint256) addressToTime;

    mapping(address => uint256) private currentTime;
    mapping(address => uint256) private unlockedPart;

    mapping(address => uint256) private addressToPayed;

    uint256 deadline = 200 days;

    IERC20 private immutable _token;

    constructor(address token_) {
        require(token_ != address(0x0));
        _token = IERC20(token_);
    }

    function deposit(uint256 amount) external {
        require(amount > 0);
        require(_token.balanceOf(msg.sender) > amount);
        require(addressToAmount[msg.sender] == 0);

        _token.transferFrom(msg.sender, address(this), amount);
        addressToAmount[msg.sender] = amount;
        //addressToTime[msg.sender] = getCurrentTime();
        currentTime[msg.sender] = getCurrentTime();
    }

    modifier unlockedPartUpgrade(address user) {
        if (getCurrentTime() > currentTime[user]) {
            uint256 full = (getCurrentTime() - currentTime[user]) /
                (deadline / 100);
            currentTime[user] += full * (deadline / 100);
            for (uint256 i = 0; i < full; i++) {
                if (unlockedPart[user] != 100) {
                    unlockedPart[user] += 1;
                }
            }
        }
        _;
    }

    function getMoney() external unlockedPartUpgrade(msg.sender) {
        require(addressToAmount[msg.sender] > 0);

        uint256 amount = calculateReward(msg.sender);
        addressToPayed[msg.sender] += amount;
        _token.transfer(msg.sender, amount);

        if (unlockedPart[msg.sender] == 100) {
            addressToAmount[msg.sender] = 0;
            currentTime[msg.sender] = 0;
            addressToPayed[msg.sender] = 0;
            unlockedPart[msg.sender] = 0;
        }
    }

    function calculateReward(address user) internal view returns (uint256) {
        uint256 amount;
        amount = (addressToAmount[user] / 100) * unlockedPart[user];
        uint256 value = amount - addressToPayed[user];

        return value;
    }

    function getCurrentTime() internal view returns (uint256) {
        return block.timestamp;
    }

    function deposited() external view returns (uint256) {
        return addressToAmount[msg.sender];
    }

    function percentUnlocked() external view returns (uint256) {
        if (addressToAmount[msg.sender] > 0) {
            uint256 full = (getCurrentTime() - currentTime[msg.sender]) /
                (deadline / 100);
            return full;
        } else {
            return 100;
        }
    }

    function rest() external view returns (uint256) {
        return addressToAmount[msg.sender] - addressToPayed[msg.sender];
    }
}
