pragma solidity ^0.8.6;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// import "forge-std/console.sol";

struct Bounty {
    bool isClosed;
    address owner;
    uint256 prizeAmount;
    address paymentToken;
    address receiver;
    string title;
    string description;
}

struct BountyRequest {
    address hunter;
    uint256 amount;
    address bountyToken;
    bool isClosed;
}

contract UnhackedInsurance {
    Bounty[] public bountyLedger;
    mapping(uint256 => BountyRequest[]) public bountyRequests;

    function createBounty(
        uint256 _amount,
        address _paymentToken,
        address _receiver,
        string memory _title,
        string memory _description
    ) public {
        bountyLedger.push(
            Bounty(
                false,
                msg.sender,
                _amount,
                _paymentToken,
                _receiver,
                _title,
                _description
            )
        );

        emit BountyAdded(msg.sender, _receiver, _paymentToken, _amount);
    }

    function cancelBounty(uint256 _bountyId) public {
        Bounty storage b = bountyLedger[_bountyId];
        // require(msg.sender == b.owner, "Caller is not the bounty owner");
        if (msg.sender != b.owner) revert CallerNotOwner(msg.sender, b.owner);

        b.isClosed = true;
        emit BountyClosedByOwner(_bountyId);
    }

    function createBountyRequest(
        uint256 _bountyId,
        uint256 _amount,
        address _bountyToken
    ) public {
        // require(bountyLedger[_bountyId].isClosed == false, "Bounty is closed");
        if (bountyLedger[_bountyId].isClosed) revert BountyClosed();

        ERC20(_bountyToken).transferFrom(msg.sender, address(this), _amount);
        bountyRequests[_bountyId].push(
            BountyRequest(msg.sender, _amount, _bountyToken, false)
        );

        emit BountyRequestAdded(_bountyId, msg.sender, _bountyToken, _amount);
    }

    function acceptBountyRequest(uint256 _bountyId, uint256 _requestId) public {
        Bounty memory b = bountyLedger[_bountyId];
        BountyRequest memory r = bountyRequests[_bountyId][_requestId];

        // require(r.isClosed == false, "Request is closed");
        if (r.isClosed) revert RequestClosed();
        if (msg.sender != b.owner) revert CallerNotOwner(msg.sender, b.owner);
        // require(msg.sender == b.owner, "Caller is not the bounty owner");
        // require(b.isClosed == false, "Bounty is closed");
        // require(insuranceTrigered == false, "the insurance has already beeen trigered");
        bountyLedger[_bountyId].isClosed = true;
        // _removeBounty(_bountyId);

        // Transfer paymentToken to hunter
        ERC20(b.paymentToken).transferFrom(msg.sender, r.hunter, b.prizeAmount);
        // Transfer bountyToken to receiver provided
        ERC20(r.bountyToken).transfer(b.receiver, r.amount);

        emit BountyFinished(_bountyId, _requestId, r.hunter);
    }

    function cancelBountyRequest(uint256 _bountyId, uint256 _requestId) public {
        BountyRequest storage r = bountyRequests[_bountyId][_requestId];
        // require(msg.sender == r.hunter, "Only hunter can cancel request");
        if (msg.sender != r.hunter) revert CallerNotOwner(msg.sender, r.hunter);

        r.isClosed = true;
        ERC20(r.bountyToken).transferFrom(address(this), msg.sender, r.amount);
        emit BountyRequestClosed(_bountyId, _requestId);
    }

    function getBountyList() public view returns (Bounty[] memory) {
        return bountyLedger;
    }

    function getBountyRequestList(uint256 _bountId) public view returns (BountyRequest[] memory) {
        return bountyRequests[_bountId];
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

    /*//////////////////////////////////////////////
                        EVENTS
    //////////////////////////////////////////////*/

    event BountyAdded(
        address indexed sender,
        address indexed receiver,
        address indexed paymentToken,
        uint256 amount
    );
    event BountyRequestAdded(
        uint256 indexed bountId,
        address indexed hunter,
        address indexed boutyToken,
        uint256 amount
    );
    event BountyClosedByOwner(uint256 indexed bountyId);
    event BountyFinished(
        uint256 indexed bountyId,
        uint256 indexed requestId,
        address indexed hunter
    );
    event BountyRequestClosed(
        uint256 indexed bountyId,
        uint256 indexed requestId
    );

    /*//////////////////////////////////////////////
                       ERRORS
    //////////////////////////////////////////////*/

    error IndexOutOfBounds(uint256 index);
    error CallerNotOwner(address sender, address owner);
    error BountyClosed();
    error RequestClosed();
}
