// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/// @title Grader5Sandbox - Local testing clone without time limits
/// @notice Replica of Grader5 for testing exploits before mainnet deployment
contract Grader5Sandbox is Ownable {
    mapping(address => uint256) public counter;
    mapping(string => uint256) public students;
    mapping(address => bool) public isGraded;
    uint256 public studentCounter;
    uint256 public divisor = 8;
    uint256 public deadline = 10000000000000000000000;
    uint256 public startTime = 0;

    constructor() Ownable(msg.sender) payable {}

    /// @notice Simulates interaction with retrieve()
    function retrieve() external payable {
        require(msg.value > 3, "not enough money");
        counter[msg.sender]++;
        require(counter[msg.sender] < 4, "too many attempts");

        (bool sent, ) = payable(msg.sender).call{value: 1, gas: gasleft()}("");
        require(sent, "Failed to send Ether");

        if (counter[msg.sender] < 2) {
            counter[msg.sender] = 0;
        }
    }

    /// @notice Simulates grading
    /// @dev Time restrictions are removed for local testing
    function gradeMe(string calldata name) public {
        // require(block.timestamp < deadline, "The end");     // Disabled for testing
        // require(block.timestamp > startTime, "The end");     // Disabled for testing

        require(counter[msg.sender] > 1, "Not yet");

        uint256 _grade = studentCounter / divisor;
        ++studentCounter;

        if (_grade <= 6) {
            _grade = 100 - _grade * 5;
        } else {
            _grade = 70;
        }

        require(students[name] == 0, "student already exists");
        require(isGraded[msg.sender] == false, "already graded");

        isGraded[msg.sender] = true;
        students[name] = _grade;
    }

    /// @notice Admin: change divisor
    function setDivisor(uint256 _divisor) public onlyOwner {
        divisor = _divisor;
    }

    /// @notice Admin: change deadline (unused in test mode)
    function setDeadline(uint256 _deadline) public onlyOwner {
        deadline = _deadline;
    }

    /// @notice Admin: change studentCounter
    function setStudentCounter(uint256 _studentCounter) public onlyOwner {
        studentCounter = _studentCounter;
    }

    /// @notice Admin: change startTime (unused in test mode)
    function setStartTime(uint256 _startTime) public onlyOwner {
        startTime = _startTime;
    }

    /// @notice Admin: withdraw funds
    function withdraw() public onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    receive() external payable {}
}
