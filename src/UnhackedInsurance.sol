pragma solidity ^0.8.6;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract UnhackedInsurance {

    uint256 insuranceAmount;
    address insuranceToken;
    address receiverOfLostFunds;
    address insuranceCreator;
    address depositorOfLostFunds;
    address lostToken;
    uint256 amountOfLostToken;
    bool insuranceTrigered;

    function createInsurance(uint256 _insuranceAmount, address _insuranceToken, address _receiverOfLostFunds) public {
        require(bounty == 0, "The bounty has already been set");
        insuranceAmount = _bountyAmount;
        insuranceToken = _bountyToken;
        receiverOfLostFunds = _receiverOfLostFunds;
        insuranceCreator = address(msg.sender);
    }

    function depositLostFunds(uint256 _amountOfLostToken, address _lostToken) public {
        require(depositorOfLostFunds == 0, "Depositor already set");

        ERC20(_lostToken).transferFrom(msg.sender, address(this), _amountOfLostToken);

        depositLostFunds = msg.sender;
        lostToken = _lostToken;
        amountOfLostToken = _amountOfLostToken
    }

    function triggerInsurance(address depositorOfLostFunds) public {
        require(msg.sender == insuranceCreator, "Caller is not the insurance creator");
        require(insuranceTrigered == false, "the insurance has already beeen trigered");

        insuranceTrigered = true;
        ERC20(insuranceToken).transferFrom(msg.sender, address(this), insuranceAmount);
        ERC20(lostToken).transferFrom(address(this), receiverOfLostFunds, amountOfLostToken);
    }

    function collectReward(address rewardReceiver) public {
        require(msg.sender == depositLostFunds, "caller does not deserve the reward");
        require(insuranceTrigered == true, "The insurance has not been triggered");

        ERC20(insuranceToken).transferFrom(address(this), rewardReceiver, insuranceAmount);
    }

    
}