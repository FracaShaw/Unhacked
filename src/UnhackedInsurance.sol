pragma solidity ^0.8.6;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

import "forge-std/console.sol";

struct Bounty {
    bool isClosed;
    address owner;
    uint256 prizeAmount;
    address paymentToken;
    address receiver;
    string description;
}

struct BountyRequest {
    address hunter;
    uint256 amount;
    address bountyToken;
    bool isClosed;
}

contract UnhackedInsurance {

    // uint256 insuranceAmount;
    // address insuranceToken;
    // address receiverOfLostFunds;
    // address insuranceCreator;
    // address depositorOfLostFunds;
    // address lostToken;
    // uint256 amountOfLostToken;
    // bool insuranceTrigered;
    Bounty[] public bountyLedger;
    mapping(uint256 => BountyRequest[]) public bountyRequests;

    function createBounty(uint256 _amount, address _paymentToken, address _receiver, string memory description) public {
        bountyLedger.push(Bounty(false, msg.sender, _amount, _paymentToken, _receiver, description));
        // emit BountyAdded();
    }

    function cancelBounty(uint256 _bountyId) public {
        Bounty storage b = bountyLedger[_bountyId];
        require(msg.sender == b.owner, "Caller is not the bounty owner");

        b.isClosed = true;
        // emit BountyClosedByOwner(_bountyId);
    }

    function createBountyRequest(uint256 _bountyId, uint256 _amount, address _bountyToken) public {
        require(bountyLedger[_bountyId].isClosed == false, "Bounty is closed");

        console.log("SENDER", msg.sender);
        console.log("ALLOWANCE", ERC20(_bountyToken).allowance(msg.sender, address(this)));
        console.log("BALANCE HACKER", ERC20(_bountyToken).balanceOf(msg.sender));
        // console.log("DIFF", ERC20(_bountyToken).balanceOf(msg.sender) - _amount);
        console.log("AMOUNT", _amount);
        ERC20(_bountyToken).transferFrom(msg.sender, address(this), _amount);

        bountyRequests[_bountyId].push(BountyRequest(msg.sender, _amount, _bountyToken, false));
        // emit Something;
    }

    function acceptBountyRequest(uint256 _bountyId, uint256 _requestId) public {
        Bounty memory b = bountyLedger[_bountyId];
        BountyRequest memory r = bountyRequests[_bountyId][_requestId];

        require(r.isClosed == false, "Request is closed");
        require(msg.sender == b.owner, "Caller is not the bounty owner");
        // require(b.isClosed == false, "Bounty is closed");
        // require(insuranceTrigered == false, "the insurance has already beeen trigered");
        bountyLedger[_bountyId].isClosed = true;
        // _removeBounty(_bountyId);

        // Transfer paymentToken to hunter
        ERC20(b.paymentToken).transferFrom(msg.sender, r.hunter, b.prizeAmount);
        // Transfer bountyToken to receiver provided
        ERC20(r.bountyToken).transfer(b.receiver, r.amount);

        // emit BountyClosed();
    }

    function cancelBountyRequest(uint256 _bountyId, uint256 _requestId) public {
        BountyRequest storage r = bountyRequests[_bountyId][_requestId];
        require(msg.sender == r.hunter, "Only hunter can cancel request");

        r.isClosed = true;
        ERC20(r.bountyToken).transferFrom(address(this), msg.sender, r.amount);
        // emit Something();
    }

    // function _removeBounty(uint256 _bountyId) internal {
    //     uint256 l = bountyLedger.length;

    //     if (index >= l) revert IndexOutOfBounds(index);

    //     bountyLedger[_bountyId] = bountyLedger[l - 1];
    //     bountyLedger.pop();
    // }

    // function collectReward(address rewardReceiver) public {
    //     require(msg.sender == depositLostFunds, "caller does not deserve the reward");
    //     require(insuranceTrigered == true, "The insurance has not been triggered");

    //     ERC20(insuranceToken).transferFrom(address(this), rewardReceiver, insuranceAmount);
    // }
    error IndexOutOfBounds(uint256 index);
}