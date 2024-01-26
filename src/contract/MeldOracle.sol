// SPDX-License-Identifier: MIT

pragma solidity 0.8.20;
import "@openzeppelin/contracts/access/Ownable.sol";

interface ISupraSValueFeed {
    // Data structure to hold the pair data
    struct priceFeed {
        uint256 round;
        uint256 decimals;
        uint256 time;
        uint256 price;
    }

    // Data structure to hold the derived/connverted data pairs.  This depends on your requirements.

    struct derivedData {
        int256 roundDifference;
        uint256 derivedPrice;
        uint256 decimals;
    }

    // Below functions enable you to retrieve different flavours of S-Value
    // Term "pair ID" and "Pair index" both refer to the same, pair index mentioned in our data pairs list.

    // Function to retrieve the data for a single data pair
    function getSvalue(
        uint256 _pairIndex
    ) external view returns (priceFeed memory);

    //Function to fetch the data for a multiple data pairs
    function getSvalues(
        uint256[] memory _pairIndexes
    ) external view returns (priceFeed[] memory);

    // Function to convert and derive new data pairs using two pair IDs and a mathematical operator multiplication(*) or division(/).
    //** Curreently only available in testnets
    function getDerivedSvalue(
        uint256 pair_id_1,
        uint256 pair_id_2,
        uint256 operation
    ) external view returns (derivedData memory);

    // Function to check  the latest Timestamp on which a data pair is updated. This will help you check the staleness of a data pair before performing an action.
    function getTimestamp(uint256 _tradingPair) external view returns (uint256);
}

contract MeldOracleContract is Ownable(msg.sender) {
    ISupraSValueFeed internal sValueFeed;

    constructor(ISupraSValueFeed _sValueFeed) {
        sValueFeed = _sValueFeed;
    }

    function getPrice(
        uint256 _priceIndex
    ) external view returns (ISupraSValueFeed.priceFeed memory) {
        return sValueFeed.getSvalue(_priceIndex);
    }

    function getPriceForMultiplePair(
        uint256[] memory _pairIndexes
    ) external view returns (ISupraSValueFeed.priceFeed[] memory) {
        return sValueFeed.getSvalues(_pairIndexes);
    }

    function getDerivedValueOfPair(
        uint256 pair_id_1,
        uint256 pair_id_2,
        uint256 operation
    ) external view returns (ISupraSValueFeed.derivedData memory) {
        return sValueFeed.getDerivedSvalue(pair_id_1, pair_id_2, operation);
    }

    // ---Utils----
    function getSupraSvalueFeed() external view returns (ISupraSValueFeed) {
        return sValueFeed;
    }

    function updateSupraSvalueFeed(
        ISupraSValueFeed _newSValueFeed
    ) external onlyOwner {
        sValueFeed = _newSValueFeed;
    }
}
