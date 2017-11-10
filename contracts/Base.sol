pragma solidity ^0.4.8;


contract Base {

  address pseudonym_id ;
  string request_transaction_id ;
  string linking_id ;
  string search_term ;

  struct Vendor{
  	string offer_transaction_id ;
  	string request_transaction_id ;
  	string pseudonym_id ;
  	/// string session_key ;
  	/// string cat_offer_value ;
  	/// string bonus_offer_value ;
  	/// string nonce ;
  	bool seen ;
  }

  struct View{
  	string view_transaction_id ;
  	string offer_transaction_id ;
  	string pseudonym_id ;
  	string linking_id ;
  	/// string session_key ;
  	/// string cat_offer_value ;
  	/// string bonus_offer_value ;
  	/// string nonce ;
  	///bool seen ;
  }
Vendor[] public vendors;
View[] public views;

function request(string transaction_id, string link_id, string search_item) {
    request_transaction_id = transaction_id;
    linking_id = link_id;
    pseudonym_id = msg.sender;
    search_term = search_item;
}

function get_transaction_id() constant returns (string) {
    return request_transaction_id;
}

function get_pseudonym_id() constant returns (address) {
    return pseudonym_id;
}

function get_linking_id() constant returns (string) {
    return linking_id;
 }

function get_search_term() constant returns (string) {
    return search_term;
}

function offer(string offer_transaction, string request_transaction,
				string pseudonym){

				/// comparing strings with references does not work. need to use StringUtils or figure out another way
				/// require(StringUtils.equal(request_transaction_id,request_transaction));
				Vendor memory ve = Vendor({offer_transaction_id :offer_transaction , request_transaction_id:request_transaction, pseudonym_id : pseudonym, seen: false });

				/// Need to refactor this. Not enough stack space
				/// , session_key: session_key, cat_offer_value:cat_offer_value, bonus_offer_value: bonus_offer_value, nonce: nonce, seen: false
				vendors.push(ve);
				
				}


function view_offer (string view_transaction, string offer_transaction, string pseudonym, string linking){

	View memory view_object = View ({ view_transaction_id: view_transaction, offer_transaction_id: offer_transaction, pseudonym_id: pseudonym, linking_id:linking});
	/// Need a check on offer transaction id to make boolean in offer array true. This will not compare string references.
	/// Need to look at an alternate way
	/// for now, insert these in the array of views.	
	views.push(view_object);
}

}