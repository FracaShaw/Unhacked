// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.6;

import "forge-std/Script.sol";
import "forge-std/Vm.sol";
import "../src/UnhackedInsurance.sol";
import "../src/USDT.sol";
import "../src/WBTC.sol";

contract DeployInsurance is Script {
    function setUp() public {}

    UnhackedInsurance unhackedI;
    USDT paymentToken;
    WrappedBTC bountyToken;

    // uint256 internal victimePrivateKey;
    // uint256 internal hackerPrivateKey;

    // address internal victimeAddress;
    // address internal hackerAddress;
    address receiverAddr;

    address hunter;
    uint256 hunterKey;

    address owner;
    uint256 ownerKey;

    // uint256 victimePayementBalance;
    // uint256 hackerRequestedBalance;

    // uint256 amountRequested = 1e8; // 1WBTC
    // uint256 offer = 1e11; // 10k usdt

    // 1 Flow company -> create bounty with some money
    // 2 Flow hacker -> create request
    // 3 company -> accept request
    // be happy

    function setBounty(uint256 _amount, string memory _title, string memory _description) public {
        vm.startBroadcast(owner);
        unhackedI.createBounty(_amount, address(paymentToken), receiverAddr, _title, _description);
        vm.stopBroadcast();
    }

    function setBountyRequest(uint256 _bountyId, uint256 _amount) public {
        vm.startBroadcast(hunter);
        bountyToken.approve(address(unhackedI), _amount);
        unhackedI.createBountyRequest(_bountyId, _amount, address(bountyToken));
        vm.stopBroadcast();
    }

    function finishBounty(uint256 _bountyId, uint256 _requestId, uint256 _paymentAmount) public {
        vm.startBroadcast(owner);
        paymentToken.approve(address(unhackedI), _paymentAmount);
        unhackedI.acceptBountyRequest(_bountyId, _requestId);
        vm.stopBroadcast();
    }


    // function setVictimeAndHacker() internal {
    //     victimePrivateKey = 0x5de4111afa1a4b94908f83103eb1f1706367c2e68ca870fc3fb9a804cdab365a;
    //     hackerPrivateKey = 0x7c852118294e51e653712a81e05800f419141751be58f605c371e15141b007a6;

    //     victimeAddress = vm.addr(victimePrivateKey);
    //     console.log("victimeAddress: ", victimeAddress);
    //     hackerAddress = vm.addr(hackerPrivateKey);
    //     console.log("hackerAddress: ", hackerAddress);

    //     vm.startBroadcast(victimeAddress);
    //     victimePayementBalance = 10000000000000000000000000;
    //     vm.stopBroadcast();

    //     vm.startBroadcast(hackerAddress);
    //     hackerRequestedBalance = 1800000000000000;
    //     tokenRequested.getFaucet(hackerRequestedBalance);
    //     vm.stopBroadcast();
    // }

    // function VictimeCreatesSettlement() internal {
    //     Unhacked.Settlement memory settlement;
    //     settlement.tokenRequested = address(tokenRequested);
    //     settlement.paymentToken = address(paymentToken);
    //     settlement.auditor = hackerAddress;
    //     settlement.settlement = "Yolo swag";
    //     settlement.amountRequested = amountRequested;
    //     settlement.offer = offer;

    //     vm.startPrank(victimeAddress);
    //     paymentToken.approve(address(unhacked), offer);
    //     unhacked.createSettlement(settlement);
    //     vm.stopPrank();
    // }

    function run() public {
        vm.startBroadcast();

        unhackedI = new UnhackedInsurance();
        console.log("Unhacked contract address: ", address(unhackedI));
        paymentToken = new USDT();
        console.log("USDT contract address: ", address(paymentToken));
        bountyToken = new WrappedBTC();
        console.log("BTC contract address: ", address(bountyToken));

        hunterKey = 0x4ce522d8ff77b42a9016c3c804c31ec582c264b6a8c8240f870c4a8136622d20;
        hunter = vm.addr(hunterKey);

        // ownerKey = 0x5de4111afa1a4b94908f83103eb1f1706367c2e68ca870fc3fb9a804cdab365a;
        owner = vm.addr(hunterKey);
        receiverAddr = owner;

        bountyToken.getFaucet(1 ether, hunter);
        paymentToken.getFaucet(1 ether, owner);

        vm.stopBroadcast();

        uint256 bId = 0;
        uint256 rId = 0;
        uint256 offer = 1200 gwei;
        uint256 valueRetrived = 2400 gwei;

        string memory s = "To deploy blablabla";
        string memory title = "To deploy blablabla";

        setBounty(offer, title, s);
        setBountyRequest(bId, valueRetrived);
        // finishBounty(bId, rId, offer);

        // setVictimeAndHacker();
        // VictimeCreatesSettlement();
    }
}
