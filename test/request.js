var Request = artifacts.require("./Request.sol");

contract('Request', function() {
  it("it should create Request", function() {
    return Request.deployed().then(function(instance) {
      instance.createRequest("123", "456", web3.fromAscii('cars', 32));
      return instance.get_transaction_details("123");
    }).then(function(search_term){
      assert.equal(web3.toUtf8(search_term), "cars", "Incorrect search term returned.");
    });
  });
});
