
// Contract infos
var contractADDR = "";
var contractABI = require("../contracts/Matryx.json");

// Init web3
var Web3 = require('web3');
if (typeof web3 !== 'undefined') {
  var web3 = new Web3(web3.currentProvider)
}
else {
  var web3 = new Web3(new Web3.providers.HttpProvider('http://geth:8545'))
}

// Prepare contract obj
var truffle = require('truffle-contract');
var contract = truffle(contractABI);
contract.setProvider(web3.currentProvider);
//var contractCallable = {};
var contractCallable = contract.at(contractADDR);

// Return as module
module.exports = {
    api: contractCallable,
    web3: web3,
};
