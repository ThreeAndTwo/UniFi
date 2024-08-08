// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import { BN254 } from "eigenlayer-middleware/libraries/BN254.sol";
import { ISignatureUtils } from "eigenlayer/interfaces/ISignatureUtils.sol";

/**
 * @title IUniFiAVSManager
 * @notice Interface for the UniFiAVSManager contract.
 */
interface IUniFiAVSManager {
    /**
     * @notice Struct used when registering a new ecdsa key
     * @param registrationSignature is the registration message signed by the private key of the validator
     * @param pubkeyG1 is the corresponding G1 public key of the validator
     * @param pubkeyG2 is the corresponding G2 public key of the validator
     * @param ecdsaPubKeyHash the hash of the ecdsa to be registered
     * @param salt the salt used to generate the signature
     * @param expiry the expiration timestamp (UTC) of the signature
     */
    struct ValidatorRegistrationParams {
        BN254.G1Point registrationSignature;
        BN254.G1Point pubkeyG1;
        BN254.G2Point pubkeyG2;
        bytes32 ecdsaPubKeyHash;
        bytes32 salt;
        uint256 expiry;
    }

    /**
     * @notice Struct to hold validator data
     * @param blsPubKeyHash is the hash of the BLS public key
     * @param eigenPod is the address of the associated EigenPod
     */
    struct ValidatorData {
        bytes32 blsPubKeyHash;
        address eigenPod;
    }

    /**
     * @notice Error thrown when the sender is not an operator
     */
    error NotOperator();

    /**
     * @notice Error thrown when the pod owner does not have an EigenPod
     */
    error NoEigenPod();

    /**
     * @notice Error thrown when the pod owner has not delegated to the operator
     */
    error NotDelegatedToOperator();

    /**
     * @notice Error thrown when the validator is not active
     */
    error ValidatorNotActive();

    /**
     * @notice Error thrown when the signature is invalid
     */
    error InvalidSignature();

    /**
     * @notice Event emitted when an operator is registered to AVS
     * @param operator The address of the registered operator
     * @param podOwner The address of the pod owner
     */
    event OperatorRegistered(address indexed operator, address indexed podOwner);

    /**
     * @notice Event emitted when a validator is registered
     * @param podOwner The address of the pod owner
     * @param ecdsaPubKeyHash The hash of the ECDSA public key
     * @param blsPubKeyHash The hash of the BLS public key
     */
    event ValidatorRegistered(address indexed podOwner, bytes32 indexed ecdsaPubKeyHash, bytes32 blsPubKeyHash);

    /**
     * @notice Event emitted when an operator is deregistered from AVS
     * @param operator The address of the deregistered operator
     */
    event OperatorDeregistered(address indexed operator);

    /**
     * @notice Registers an operator to AVS
     * @param podOwner The address of the pod owner
     * @param operatorSignature The signature of the operator with salt and expiry
     */
    function registerOperator(address podOwner, ISignatureUtils.SignatureWithSaltAndExpiry memory operatorSignature)
        external;

    /**
     * @notice Registers a validator
     * @param podOwner The address of the pod owner
     * @param params The parameters for validator registration
     */
    function registerValidator(address podOwner, ValidatorRegistrationParams calldata params) external;

    /**
     * @notice Deregisters an operator from AVS
     */
    function deregisterOperator() external;
}
