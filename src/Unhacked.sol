pragma solidity ^0.8.6;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Unhacked {

    struct Settlement {
        address tokenRequested;
        address paymentToken;
        address creator;
        address auditor;
        string settlement;
        uint256 amountRequested;
        uint256 offer;
        bool completed;
        bool canceled;
    }

    uint16 settlementNumber; //this can probably be improved
    Settlement[] settlements;

    function createSettlement(Settlement memory settlement) public returns(uint16 index) {
        ERC20(settlement.paymentToken).transferFrom(msg.sender, address(this), settlement.offer);

        settlements.push(settlement);

        uint16 settlementNumberCpy = settlementNumber;
        settlementNumber++;
        return(settlementNumberCpy);
    }

    function acceptSettlemen(uint16 settlementNumberToAccepte) public {
        Settlement memory settlement = settlements[settlementNumberToAccepte]; 
        require(msg.sender == settlement.auditor, "Caller is not the auditor");
        require(settlement.completed == false, "This settlement has already been completed");
        require(settlement.canceled == false, "This settlement has been canceled");

        settlements[settlementNumberToAccepte].completed = true;

        ERC20(settlement.tokenRequested).transferFrom(msg.sender, settlement.creator, settlement.amountRequested);
        ERC20(settlement.paymentToken).transfer(settlement.auditor, settlement.offer);
    }

    function cancelSettlement(uint16 settlementNumberToCancel) public {
        Settlement memory settlement = settlements[settlementNumberToCancel];
        require(msg.sender == settlement.creator, "Caller is not the settlement creator");
        require(settlement.canceled == false, "This settlement has already been canceled");
        require(settlement.completed == false, "This settlement has already been completed");

        settlements[settlementNumberToCancel].canceled = true;

        ERC20(settlement.paymentToken).transfer(settlement.creator, settlement.offer);
    }

    function getSettlementTerms(uint16 settlementNumberToQuery) public view returns(Settlement memory settlement) {
        return(settlements[settlementNumberToQuery]);
    }
}