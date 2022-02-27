// SPDX-License-Identifier: MIT
// author: Juan Pablo Ibarbo Herrera
pragma solidity ^0.8.7;

// background assignment exercise 1

// Documentation:
// write a simple "hello world" smart contract
// store an unsigned integer 
// then retrieve it

contract HelloWorld { // name of the contract, hello world smart contract

    uint public A = 123; // unsigned integer: means that the number has to
                         // be greater than or equal to 0, it's not possible to
                         // use negative numbers "only 0 or positive numbers"
}

// deploy the smart contract in the local blockchain