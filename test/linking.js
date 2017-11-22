var Request = artifacts.require("./Request.sol");
var Offer = artifacts.require("./Offer.sol");
var View = artifacts.require("./ViewOffer.sol")
var sodium = require('libsodium-wrappers');
var utils = require('web3-utils');

contract('Request', function() {
  it("testing linkability", function() {
    var transactionID1 = sodium.randombytes_random();
    var transactionID2 = sodium.randombytes_random();
    var offer_id = sodium.randombytes_random();
    var view_id = sodium.randombytes_random();
    var nonce;

    //STEP 1: CUSTOMER - creating requests
    //Create unique key pairs for each transaction
    var keypair1 = sodium.crypto_sign_keypair();
    var keypair2 = sodium.crypto_sign_keypair();
    var signed1, signed2;

    return Request.deployed().then(function(RequestInstance) {
      //Creating requests to use for linking
      RequestInstance.createRequest(transactionID1, sodium.to_hex(keypair1.publicKey), web3.fromAscii('shoes', 32));
      RequestInstance.createRequest(transactionID2, sodium.to_hex(keypair1.publicKey), web3.fromAscii('bags', 32));
      //STEP 2: VENDOR - creating offers in response to request   
      //check if request exists
      return RequestInstance.get_isEntity(transactionID2);
    }).then(function(isExists){
      console.log("vendor checks transaction exists: " + transactionID2 + " : " + isExists);
      if (isExists)
        return Offer.deployed();
    }).then(function(OfferInstance){ 
      //create offer
      nonce = sodium.randombytes_random(); //generate nonce
      var CAT_value = 10;
      var bonus_item = "shoes";
      var bonus_value = 5;
      OfferInstance.createOffer(offer_id, transactionID2, "", CAT_value, 
       bonus_item , bonus_value, nonce, "");
      return OfferInstance.getOfferDetails(offer_id);
    }).then(function(offer_details){
      //STEP 3: CUSTOMER - create view in response to offer
      console.log("customer gets offer details: " + offer_details); //learns about bonus offers
      nonce = offer_details[3];
      signed1 = sodium.crypto_sign_detached(offer_details[3], keypair1.privateKey, null);
      signed2 = sodium.crypto_sign_detached(offer_details[3], keypair2.privateKey, null);
      
      console.log("customer signed 1: " + sodium.to_hex(signed1));
      console.log("customer signed 2: " + sodium.to_hex(signed2));
      return View.deployed();
    }).then(function(ViewInstance){
      ViewInstance.createView(view_id, offer_id, sodium.to_hex(keypair2.publicKey),  sodium.to_hex(signed1), transactionID1, sodium.to_hex(signed2), transactionID2);
      
      //STEP 4: VENDOR - verify linkability
      return ViewInstance.getViewDetails(offer_id);
    }).then(function(view_details){
      console.log("vendor gets view details: " + view_details); //learns about bonus offers
      console.log("signed 1 : " + view_details[0]);
      console.log("signed 1 : " + sodium.from_hex(view_details[0]));
      console.log("vendor verifies signs nonce using linking pub key 1: " + sodium.crypto_sign_verify_detached(signed1, nonce, keypair1.publicKey));
      console.log("vendor verifies signs nonce using linking pub key 2: " + sodium.crypto_sign_verify_detached(signed2, nonce, keypair2.publicKey));
      return Request.deployed();
    }).then(function(requestInstance){
      return requestInstance.get_transaction_details(transactionID1);
    }).then(function(item_1){
      console.log("vendor verifies item bought: " + web3.toUtf8(item_1));
    });
  });
});