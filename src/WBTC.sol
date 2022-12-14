// SPDX-License-Identifier: MIT
pragma solidity 0.8.6;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract WrappedBTC is ERC20 {
    constructor() ERC20("Test Wrapped BTC", "t.wBTC") {
        _mint(msg.sender, 10000000000000000000000000);
    }

    function decimals() public view virtual override returns (uint8) {
        return 8;
    }

    function getFaucet(uint256 amount, address acc) public {
        _mint(acc, amount);
    }
}
