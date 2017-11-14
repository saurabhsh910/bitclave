pragma solidity ^0.4.4;

contract Request{
	
	struct CustomerInfo{

		bytes32 transaction_id ;
		bytes32 linking_id ;
		address pseudonym_id ;
		bytes32 activity_type ;
		bytes32 search_term ;
		bool isEntity ;
		// string time_stamp ;
		// string encrypted_blob ;
		// string signed_digest_private_link_id ;
		// string signed_digest_psuedo_id ;
	}
	
	CustomerInfo c ;
	mapping(bytes32 => CustomerInfo)  public request_database;
	 
	function set_customer_details( bytes32 t_id , bytes32 l_id , bytes32 search_name){
		CustomerInfo memory customer = CustomerInfo({transaction_id : t_id, linking_id : l_id, pseudonym_id: msg.sender, activity_type: "request", search_term: search_name, isEntity: true }) ;
		c = customer;
		request_database[t_id].transaction_id = t_id;
		request_database[t_id].linking_id = l_id;
		request_database[t_id].search_term = search_name;
		request_database[t_id].isEntity = true;
	}

	function get_transaction_id() constant returns (bytes32) {
    	return c.transaction_id;
	}
	
	function get_linking_id() constant returns (bytes32) {
    	return c.linking_id;
	}

	function get_transaction_details(bytes32 t_id) constant returns (bytes32) {
    	return request_database[t_id].search_term;
	}

	function get_isEntity(bytes32 t_id) constant returns (bool){
		return request_database[t_id].isEntity;
	}

}