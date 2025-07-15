# Grader5 Exploit – Solidity Final Project

## Overview

This smart contract exploits the `Grader5` contract using a controlled **reentrancy attack** on the `retrieve()` function. The objective is to increment the caller's internal counter beyond the usual reset threshold and subsequently call `gradeMe()` to register a valid alias.

## Exploit Strategy

- **Reentrancy abuse**: `Grader5.retrieve()` sends 1 wei back to the caller. The exploit contract leverages this transfer to re-enter `retrieve()` through the `receive()` function.
- **Counter bypass**: Normally, the internal counter is reset if it's below 2. This exploit avoids the reset by chaining `retrieve()` calls within a single transaction.

## Deployment

Deploy the `Grader5Reentrance` contract with:

- `_grader`: the address of the deployed `Grader5` contract.
- `_alias`: your alias (e.g., `"Alias"`).

