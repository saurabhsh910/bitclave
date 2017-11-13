pragma solidity ^0.4.4;

contract Request{
	
	struct CustomerInfo{

		string transaction_id ;
		string linking_id ;
		address pseudonym_id ;
		string activity_type ;
		string search_term ;
		// string time_stamp ;
		// string encrypted_blob ;
		// string signed_digest_private_link_id ;
		// string signed_digest_psuedo_id ;
	}
	
	CustomerInfo c ;
	mapping(string => CustomerInfo)  keys;
	 
	function set_customer_details( string t_id , string l_id , string search_name){
		CustomerInfo memory customer = CustomerInfo({transaction_id : t_id, linking_id : l_id, pseudonym_id: msg.sender, activity_type: "request", search_term: search_name }) ;
		c = customer;
		keys[t_id].transaction_id = t_id;
		keys[t_id].linking_id = l_id;
		keys[t_id].search_term = search_name;
	}

	function get_transaction_id() constant returns (string) {
    	return c.transaction_id;
	}
	
	function get_linking_id() constant returns (string) {
    	return c.linking_id;
	}

	function get_transaction_details(string t_id) constant returns (string) {
    	return keys[t_id].search_term;
	}

}