# Name

TMNG Token


# Description

TMNG Token is a utility token for EREA World AG company. It is a ERC20 token with additional freezing and releasing options. 
Contract will distribute following amounts than freeze them directly, after the dedicated time period it will start releasing the frozen tokens. 


Minting

- Total Supply : 500.000.000


Distribution

- Account - 1 : 100.000.000 -> Completely Frozen


For the following accounts these rules are applied : 
❖ Locked permanently till 30st April 2022 
❖ After that opening on all those wallets 1% per month till 1st of January 2023 and then open up completely

- Account - 2 : 21.000.000 ❖
- Account - 3 : 21.000.000 ❖
- Account - 4 : 21.000.000 ❖
- Account - 5 : 21.000.000 ❖
- Account - 6 : 16.000.000 ❖


## ERC20 Token

- Base contract is from Open Zeppelin : // File: [Link](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol)
- Safemath library imported from Open Zeppelin : // File: [Link](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol)


## Distribute & Freeze 

- 100.000.000 * Completely Frozen : 
```
    /* Test account - Needs to be updated */
    transfer(
        0x4a471C71E25b61A839610A5BFb722b096Dc5Bc57,
        100000000 * (10**uint256(decimals()))
    );
```


- Other Accounts * Partially Frozen 

```
/* Test account - Needs to be updated */
    transferAndFreeze(
        0x763F63EbADBE326970811f29ECFE338aeC4BfbbF,
        21000000 * (10**uint256(decimals()))
    );
    /* Test account - Needs to be updated */
    transferAndFreeze(
        0xe06a78e06B66a8F23066Ee6d2D1E82add4F936F9,
        21000000 * (10**uint256(decimals()))
    );
    /* Test account - Needs to be updated */
    transferAndFreeze(
        0xd1DE26734e661609402E7a1162c1cFE7460F3bf4,
        21000000 * (10**uint256(decimals()))
    );
    /* Test account - Needs to be updated */
    transferAndFreeze(
        0x78367EB70F062E6436B88aBE1CD2dBEe43fD0e93,
        21000000 * (10**uint256(decimals()))
    );
    /* Test account - Needs to be updated */
    transferAndFreeze(
        0xc29799d5d622C4C0e8aC16d7bCCa1e4aBb3C05D6,
        16000000 * (10**uint256(decimals()))
    );
```


## Releasing

Releasing editted : Now we are first burning the dedicated tokens and when the relase time hits we mint them.

```
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
```

# Usage

After deployment, you need to trigger release() function.


# Support

Please contact support@tmn-global.com


# Roadmap

We are on the initial phase for developing the contract. After audits final version will be released.


# Author

Erea World AG


