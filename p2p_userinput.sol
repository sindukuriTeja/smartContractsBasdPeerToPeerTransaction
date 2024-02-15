pragma solidity ^0.8.0;

contract SimpleP2PBalance {
    struct Prosumer {
        address id;
        uint256 energyOffer;
        uint256 wallet;  // Updated type to uint256 for balance
    }

    struct Consumer {
        address id;
        uint256 energyRequest;
        uint256 bidPrice;
        uint256 wallet;  // Updated type to uint256 for balance
    }

    function LocalEnergyTransfer(
        address prosumerId, uint256 prosumerEnergyOffer, uint256 prosumerWallet,
        address consumerId, uint256 consumerEnergyRequest, uint256 consumerBidPrice, uint256 consumerWallet
    ) public {
        uint256 balanceLocalEnergy;

        if (prosumerEnergyOffer >= consumerEnergyRequest) {
            balanceLocalEnergy = consumerBidPrice * consumerEnergyRequest;
            prosumerEnergyOffer -= consumerEnergyRequest;
            consumerEnergyRequest = 0;
        } else {
            balanceLocalEnergy = consumerBidPrice * prosumerEnergyOffer;

            // Ensure subtraction doesn't result in underflow
            if (balanceLocalEnergy <= consumerWallet) {
                consumerEnergyRequest -= prosumerEnergyOffer;
                prosumerEnergyOffer = 0;
            } else {
                balanceLocalEnergy = consumerWallet;
                consumerEnergyRequest -= balanceLocalEnergy / consumerBidPrice;
                prosumerEnergyOffer = 0;
            }
        }

        prosumerWallet += balanceLocalEnergy;
        consumerWallet -= balanceLocalEnergy;
    }
}