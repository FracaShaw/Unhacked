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

    function setBounty(uint256 _amount, string memory _description) public {
        vm.startBroadcast(owner);
        unhackedI.createBounty(_amount, address(paymentToken), receiverAddr, _description);
        vm.stopBroadcast();
    }

    function setBountyRequest(uint256 _bountyId, uint256 _amount) public {
        vm.startBroadcast(hunter);
        bountyToken.approve(address(unhackedI), _amount);
        console.log("HUNTER", hunter);
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
        // uint256 deployerPk = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
        vm.startBroadcast();

        unhackedI = new UnhackedInsurance();
        console.log("Unhacked contract address: ", address(unhackedI));
        paymentToken = new USDT();
        console.log("USDT contract address: ", address(paymentToken));
        bountyToken = new WrappedBTC();
        console.log("BTC contract address: ", address(bountyToken));

        vm.stopBroadcast();


        hunterKey = 0x7c852118294e51e653712a81e05800f419141751be58f605c371e15141b007a6;
        hunter = vm.addr(hunterKey);

        ownerKey = 0x5de4111afa1a4b94908f83103eb1f1706367c2e68ca870fc3fb9a804cdab365a;
        owner = vm.addr(ownerKey);
        receiverAddr = owner;

        bountyToken.getFaucet(100000000000 ether, hunter);
        paymentToken.getFaucet(10000 ether, owner);

        uint256 bId = 0;
        uint256 rId = 0;
        uint256 offer = 12 gwei;
        uint256 valueRetrived = 1098 gwei;

        string memory s = "To deploy blablabla";

        setBounty(offer, s);
        setBountyRequest(bId, valueRetrived);
        finishBounty(bId, rId, offer);

        // setVictimeAndHacker();
        // VictimeCreatesSettlement();
    }
}