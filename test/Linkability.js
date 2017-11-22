var Request = artifacts.require("./Request.sol");
//var Offer = artifacts.require("./Offer.sol");
var sodium = require('libsodium-wrappers');

contract('Request', function() {
  it("testing signing", function() {
    return Request.deployed().then(function(instance) {
      var transactionID1 = sodium.randombytes_random();
      var transactionID2 = sodium.randombytes_random();

      //Create unique key pairs for each transaction
      var keypair1 = sodium.crypto_sign_keypair();
      var keypair2 = sodium.crypto_sign_keypair();

      console.log("Reached1");
      //Creating 1 request history
      instance.createRequest("123", keypair1, web3.fromAscii('shoes', 32));
      instance.createRequest("456", keypair2, web3.fromAscii('bags', 32));
      console.log("Reached2");
      /*
      var requestEvent = instance.RequestEvent({}, "bags");
      console.log("Reached1");
      requestEvent.watch(function(err, response){ //set up listener for the Request creation event
        //event detected  
        console.log("response: " + response);
        let search_term = instance.get_transaction_details.call("123");
        assert.equal(web3.toUtf8(search_term), "cars", "Incorrect search term returned.");
      });*/
      return instance.get_transaction_details.call("123");

    }).then(function(result){
      
      //instance.createRequest("234", keypair1, web3.fromAscii('shoes', 32));
      
      /*
      let Offer = Offer.deployed();
      
            sodium.crypto_sign_detached('12345', keypair.privateKey, null);
            sodium.crypto_sign_verify_detached(signed, "12345", keypair.publicKey);*/
      assert.equal(search_term, "cars", "Incorrect search term returned.");
    });
  });
});
