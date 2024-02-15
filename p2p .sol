// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EnergyTransaction {
    struct Prosumer {
        uint256 energyAmount;
        uint256 costPerUnit;
    }

    struct Consumer {
        uint256 energyNeeded;
        uint256 buyingRate;
    }

    uint256 public numberOfProsumers;
    uint256 public numberOfConsumers;

    mapping(uint256 => Prosumer) public prosumers;
    mapping(uint256 => Consumer) public consumers;

    event EnergySold(uint256 prosumerIndex, uint256 consumerIndex, uint256 energyAmount, uint256 totalPrice);
    event EnergyTransactionDetails(
        address indexed prosumerAddress,
        address indexed consumerAddress,
        uint256 energyAmount,
        uint256 totalPrice
    );

    constructor() {
        numberOfProsumers = 3;
        numberOfConsumers = 2;

        prosumers[0] = Prosumer(100, 5);
        prosumers[1] = Prosumer(150, 5);
        prosumers[2] = Prosumer(200, 3);

        consumers[0] = Consumer(80, 3);
        consumers[1] = Consumer(120, 5);
    }

    function conductTransaction(uint256 prosumerIndex, uint256 consumerIndex) external {
        require(prosumerIndex < numberOfProsumers && consumerIndex < numberOfConsumers, "Invalid prosumer or consumer index");

        Prosumer memory prosumer = prosumers[prosumerIndex];
        Consumer memory consumer = consumers[consumerIndex];

        require(prosumer.energyAmount > 0 && consumer.energyNeeded > 0, "Prosumer or consumer has no energy");

        uint256 energySold = (prosumer.energyAmount < consumer.energyNeeded) ? prosumer.energyAmount : consumer.energyNeeded;
        uint256 totalPrice = energySold * prosumer.costPerUnit;

        require(totalPrice == energySold * consumer.buyingRate, "Consumer and prosumer rates are not equal");

        prosumers[prosumerIndex].energyAmount -= energySold;
        consumers[consumerIndex].energyNeeded -= energySold;

        emit EnergySold(prosumerIndex, consumerIndex, energySold, totalPrice);
        emit EnergyTransactionDetails(
            address(this),
            address(this),
            energySold,
            totalPrice
        );
    }
}

 }
