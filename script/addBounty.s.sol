// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.6;

import "forge-std/Script.sol";
import "forge-std/Vm.sol";
import "../src/UnhackedInsurance.sol";
import "../src/USDT.sol";
import "../src/WBTC.sol";

contract addBounty is Script {
    function setUp() public {}

    UnhackedInsurance unhackedI = UnhackedInsurance(0x5B85812dA1C35B29e10935551360C5daa6f80Dc4);
    USDT paymentToken = USDT(0x25784622b54C7Ca85073FB1eFd89402F7bcB3B4D);
    // WrappedBTC bountyToken;

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
        unhackedI.createBounty(_amount, address(paymentToken), receiverAddr, _title, _description);
    }

    function run() public {
        uint256 bId = 0;
        uint256 rId = 0;
        uint256 offer = 1200 gwei;
        uint256 valueRetrived = 2400 gwei;

        string memory s = "To deploy blablabla";
        string memory title = "To deploy blablabla";

        uint256 a = vm.envUint("PRIVATE_KEY");
        address d = vm.addr(a);
        vm.startBroadcast(d);
        setBounty(offer, title, s);
        vm.stopBroadcast();
    }
}
