// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.6;

import "forge-std/Script.sol";
import "forge-std/Vm.sol";
import "../src/Unhacked.sol";
import "../src/USDT.sol";
import "../src/WBTC.sol";

contract Deploy is Script {
    function setUp() public {}

    Unhacked unhacked;
    USDT paymentToken;
    WrappedBTC tokenRequested;

    uint256 internal victimePrivateKey;
    uint256 internal hackerPrivateKey;

    address internal victimeAddress;
    address internal hackerAddress;

    uint256 victimePayementBalance;
    uint256 hackerRequestedBalance;

    uint256 amountRequested = 1e8; // 1WBTC
    uint256 offer = 1e11; // 10k usdt

    function setVictimeAndHacker() internal {
        victimePrivateKey = 0x5de4111afa1a4b94908f83103eb1f1706367c2e68ca870fc3fb9a804cdab365a;
        hackerPrivateKey = 0x7c852118294e51e653712a81e05800f419141751be58f605c371e15141b007a6;

        victimeAddress = vm.addr(victimePrivateKey);
        console.log("victimeAddress: ", victimeAddress);
        hackerAddress = vm.addr(hackerPrivateKey);
        console.log("hackerAddress: ", hackerAddress);

        vm.startBroadcast(victimeAddress);
        victimePayementBalance = 10000000000000000000000000;
        paymentToken.getFaucet(victimePayementBalance);
        vm.stopBroadcast();

        vm.startBroadcast(hackerAddress);
        hackerRequestedBalance = 1800000000000000;
        tokenRequested.getFaucet(hackerRequestedBalance);
        vm.stopBroadcast();
    }

    function VictimeCreatesSettlement() internal {
        Unhacked.Settlement memory settlement;
        settlement.tokenRequested = address(tokenRequested);
        settlement.paymentToken = address(paymentToken);
        settlement.auditor = hackerAddress;
        settlement.settlement = "Yolo swag";
        settlement.amountRequested = amountRequested;
        settlement.offer = offer;

        vm.startPrank(victimeAddress);
        paymentToken.approve(address(unhacked), offer);
        unhacked.createSettlement(settlement);
        vm.stopPrank();
    }

    function run() public {
        uint256 deployerPk = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;

        vm.startBroadcast();

        unhacked = new Unhacked();
        console.log("Unhacked contract address: ", address(unhacked));
        paymentToken = new USDT();
        console.log("Unhacked contract address: ", address(paymentToken));
        tokenRequested = new WrappedBTC();
        console.log("Unhacked contract address: ", address(tokenRequested));
        vm.stopBroadcast();
        

        setVictimeAndHacker();
        // VictimeCreatesSettlement();
    }
}
