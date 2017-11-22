pragma solidity ^0.4.4;

// Created by : Simran Gujral
// Basic concept: This contract creates a database of requests 
// 				  with all customer information. It has an event 
//				  which notifies the businesses when requests are 
//				  made so that they can give their offers

contract Request{
	struct CustomerInfo{
		bytes32 transaction_id ;
		string linking_id ;
		address pseudonym_id ;
		bytes32 activity_type ;
		bytes32 search_term ;
		bool isEntity ;

		/// Fields to be defined later
		// string time_stamp ;
		// string encrypted_blob ;
		// string signed_digest_private_link_id ;
		// string signed_digest_psuedo_id ;
	}
	
	// database of all requests to request information
	mapping(bytes32 => CustomerInfo)  public request_database;
	
	// event to indicate and log that a request has come in
	// do we need to provide linking id???

	event RequestEvent (bytes32 transaction_id, bytes32 search_term);

	function createRequest( bytes32 t_id , string l_id , bytes32 search_name){
		request_database[t_id] = CustomerInfo({transaction_id : t_id, linking_id : l_id, pseudonym_id: msg.sender, activity_type: "request", search_term: search_name, isEntity: true });

		// We need to create an event on the business side which listens for this event
		RequestEvent(t_id, search_name);
	}
	
	// Returns the linking id for a transacton id from the request database
	function get_linking_id(bytes32 t_id) constant returns (string) {
    	return request_database[t_id].linking_id;
	}

	// Returns the search term associated with a transaction id from the request database
	function get_transaction_details(bytes32 t_id) constant returns (bytes32) {
    	return request_database[t_id].search_term;
	}

	// Tells my offer if the entry for a transaction id is valid
	function get_isEntity(bytes32 t_id) constant returns (bool){
		return request_database[t_id].isEntity;
	}

}
