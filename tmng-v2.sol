// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";


abstract contract Releasable is ERC20 {
    uint public nonce;
    uint256 immutable public _createdDate;
    uint256 immutable public _startReleaseTime;
    uint256 public _lastReleasedDate;
    bytes32 public _hashOfLastRelease;
    uint256 immutable public _finalReleaseTime;
    uint256 public _lastReleasedBlockNumber;
    uint256 public _amount;
    address [] public releaseableAddresses;
    mapping(address => uint256) public frozenAmounts;

    event FrozenFunds(address target, uint256 amount);
    event Release(address target, uint256 amount);

    function freezeAmount(address target, uint256 amount) internal {
        _burn(target, amount * (10 ** uint256(decimals())));
        frozenAmounts[target] = amount;
        FrozenFunds(target, amount);
    }

    function transferAndFreeze(address target, uint256 amount) internal {
        transfer(target, amount);
        freezeAmount(target, amount);
        releasableAddresses.push(target);
    }

    function getFrozenAmount(address target) public view returns (uint256) {
        return frozenAmounts[target];
    }


    function _release(address target) private {
        bytes32 hashOfRelease = keccak256(abi.encodePacked(block.number, msg.data, tx.gasprice, nonce));
        require(
            block.timestamp >= _startReleaseTime,
            "current time is before first release time"
        );

        if (
            _hashOfLastRelease == hashOfRelease ||
            _lastReleasedBlockNumber == 0 ||
            block.timestamp >= _lastReleasedDate + 3 minutes
        ) {
            uint256 amount = getFrozenAmount(target) / 100;
            require(amount > 0, "no tokens to release");
            frozenAmounts[target] = frozenAmounts[target] - amount;
            _mint(target, amount * (10 ** uint256(decimals())));
            _lastReleasedDate = block.timestamp;
            _hashOfLastRelease = hashOfRelease;
            _lastReleasedBlockNumber = block.number;
            Release(target, amount * (10 ** uint256(decimals())));
        } else {
            revert("current time is before next release time");
        }
    }

    function _finalRelease(address target) private returns (bool) {
        require(
            block.timestamp >= _finalReleaseTime,
            "current time is before final release time"
        );
        uint256 amount = getFrozenAmount(target);
        require(amount > 0, "no tokens to release");
        frozenAmounts[target] = frozenAmounts[target] - amount;
        _mint(target, amount * (10 ** uint256(decimals())));
        Release(target, amount * (10 ** uint256(decimals())));
        return true;
    }

    function finalRelease() public returns (bool) {
        for (uint i = 0; i < releasableAddresses.length; i++) {
            _finalRelease(releasableAddresses[i]);
        }
        return true;
    }

    function release() public returns (bool) {
        for (uint i = 0; i < releasableAddresses.length; i++) {
            _release(releasableAddresses[i]);
        }
        nonce++;
        return true;
    }
}

contract TMNG is Releasable {
    constructor()  ERC20("TMN Global", "TMNG") {
        _mint(msg.sender, 500000000 * (10 ** uint256(decimals())));
        _createdDate = block.timestamp;
        /* Dates needs to be updated with the new roadmap */
        _startReleaseTime = 1616852443;
        _finalReleaseTime = 1616938843;
        /* Test account - Needs to be updated */
        transfer(
            0x4a471C71E25b61A839610A5BFb722b096Dc5Bc57,
            100000000 * (10 ** uint256(decimals()))
        );
        /* Test account - Needs to be updated */
        transferAndFreeze(
            0x763F63EbADBE326970811f29ECFE338aeC4BfbbF,
            21000000 * (10 ** uint256(decimals()))
        );
        /* Test account - Needs to be updated */
        transferAndFreeze(
            0xe06a78e06B66a8F23066Ee6d2D1E82add4F936F9,
            21000000 * (10 ** uint256(decimals()))
        );
        /* Test account - Needs to be updated */
        transferAndFreeze(
            0xd1DE26734e661609402E7a1162c1cFE7460F3bf4,
            21000000 * (10 ** uint256(decimals()))
        );
        /* Test account - Needs to be updated */
        transferAndFreeze(
            0x78367EB70F062E6436B88aBE1CD2dBEe43fD0e93,
            21000000 * (10 ** uint256(decimals()))
        );
        /* Test account - Needs to be updated */
        transferAndFreeze(
            0xc29799d5d622C4C0e8aC16d7bCCa1e4aBb3C05D6,
            16000000 * (10 ** uint256(decimals()))
        );
    }
}
