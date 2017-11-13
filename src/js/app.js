App = {
  web3Provider: null,
  contracts: {},

  init: function() {
    return App.initWeb3();
  },

  initWeb3: function() {
    // Initialize web3 and set the provider to the testRPC.
    if (typeof web3 !== 'undefined') {
      App.web3Provider = web3.currentProvider;
      web3 = new Web3(web3.currentProvider);
    } else {
      // set the provider you want from Web3.providers
      App.web3Provider = new Web3.providers.HttpProvider('http://127.0.0.1:9545');
      web3 = new Web3(App.web3Provider);
    }

    return App.initContract();
  },

  initContract: function() {
    $.getJSON('CatToken.json', function(data) {
      // Get the necessary contract artifact file and instantiate it with truffle-contract.
      var CatTokenArtifact = data;
      App.contracts.CatToken = TruffleContract(CatTokenArtifact);

      // Set the provider for our contract.
      App.contracts.CatToken.setProvider(App.web3Provider);
      return App.getBalances();
    });

    $.getJSON('Request.json', function(data) {
      // Get the necessary contract artifact file and instantiate it with truffle-contract.
      var RequestArtifact = data;
      App.contracts.Request = TruffleContract(RequestArtifact);

      // Set the provider for our contract.
      App.contracts.Request.setProvider(App.web3Provider);
    });

    return App.bindEvents();
  },

  bindEvents: function() {
    $(document).on('click', '#transferButton', App.handleTransfer);
    $(document).on('click', '#requestButton', App.handleRequest);
    $(document).on('click', '#findRequestButton', App.handleGetRequest);
  },

  handleTransfer: function() {
    event.preventDefault();

    var amount = parseInt($('#TTTransferAmount').val());
    var toAddress = $('#TTTransferAddress').val();

    console.log('Transfer ' + amount + ' TT to ' + toAddress);

    var CatTokenInstance;

    web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }

      var account = accounts[0];

      App.contracts.CatToken.deployed().then(function(instance) {
        CatTokenInstance = instance;

        return CatTokenInstance.transfer(toAddress, amount, {from: account});
      }).then(function(result) {
        alert('Transfer Successful!');
        return App.getBalances();
      }).catch(function(err) {
        console.log(err.message);
      });
    });
  },

  handleRequest: function() {
    event.preventDefault();
    
    var RequestInstance;
    var pseudonymID = $('#TTPseudonymTerm').val();
    var searchTerm = $('#TTSearchTerm').val();
    //var sodium = require('../../node_modules/libsodium-wrappers/dist/modules/libsodium-wrappers');
    //var testint = sodium.randombytes_random();;
    //console.log(testint);
    var transactionID = Math.floor(Math.random()*10000).toString();
    var linkingID = "1240875230985234";

    console.log('Transaction ID generated: ' + transactionID);
    web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }
  
      var account = accounts[0];
      App.contracts.Request.deployed().then(function(instance) {
        RequestInstance = instance;
        return RequestInstance.set_customer_details(transactionID, linkingID, searchTerm, {from: account});
      }).then(function(result) {
        alert('Create Request Successful!');
      }).catch(function(err) {
        console.log(err.message);
      });
    });
  },

  handleGetRequest: function(adopters, account) {
    console.log('Getting Request...');

    var RequestInstance;
    var transactionID = $('#TTTransactionID').val();
    
    web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }

      var account = accounts[0];

      App.contracts.Request.deployed().then(function(instance) {
        RequestInstance = instance;
        
        return RequestInstance.get_transaction_details(transactionID);
      }).then(function(result) {
        console.log(result);
      }).catch(function(err) {
        console.log(err.message);
      });
    });
  },

  getBalances: function(adopters, account) {
    console.log('Getting balances...');

    var CatTokenInstance;

    web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }

      var account = accounts[0];

      App.contracts.CatToken.deployed().then(function(instance) {
        CatTokenInstance = instance;

        return CatTokenInstance.balanceOf(account);
      }).then(function(result) {
        balance = result.c[0];

        $('#TTBalance').text(balance);
      }).catch(function(err) {
        console.log(err.message);
      });
    });
  }

};

$(function() {
  $(window).load(function() {
    App.init();
  });
});
