pragma solidity ^0.4.4;

contract Offer{

	struct OfferInformation{
		bytes32 offer_transaction_id ;
		bytes32 request_id ;
		bytes32 activity_type ;
		//bytes validity_timestamp ;
		address pseudonym_id ;
		bytes32 session_key ;
		uint cat_offer_value ;
		string bonus_offer_item;
		uint bonus_offer_value ;
		bytes32 nonce ;
		bytes32 private_pseudo_id ;
		bool viewed ;
	}

	// Contains a list of all offers made to all requests
	mapping(bytes32 => OfferInformation) public offer_database ;

	// mapping of requests to offers associated with them
	mapping(bytes32 => bytes32[]) public request_offer_mapping ;

	event OfferEvent ( bytes32 offer_transaction_id, bytes32 request_id, address pseudonym_id);

	// whenever an offer is made, offer information struct is generated. 
	// we check if request for that offer exists 
	// if the request for that transaction exists, we create a map which contains all offers for that request
	// structure is as follows: Request_ID => [array of offer IDS]

	function createOffer ( bytes32 offer_id, bytes32 req_id, bytes32 sess_key , uint cat_value, 
							string bonus_offer_item, uint bonus_offer_value , bytes32 nonce_info , bytes32 private_pseudonym_id){

		offer_database[offer_id] = OfferInformation({ offer_transaction_id: offer_id, request_id: req_id, activity_type: "offer", pseudonym_id: msg.sender, session_key: sess_key, cat_offer_value : cat_value , bonus_offer_item: bonus_offer_item, bonus_offer_value: bonus_offer_value,
		nonce: nonce_info, private_pseudo_id: private_pseudonym_id, viewed: false});

		bytes32[] storage request_list =  request_offer_mapping[req_id];
		request_list.push(offer_id);
		request_offer_mapping[req_id] = request_list;

		// We should have something in the client app so that only the user of a request gets this event notification
		// this is important so that only he accesses the offer id and hence the nonce.
		// we might have to figure out some other way for the nonce otherwise

		OfferEvent (offer_id, req_id, msg.sender);
	}

	// Functions to access offer details 
	function getOfferDetails(bytes32 offer_id) constant returns(uint, string, uint, bytes32){
		return (offer_database[offer_id].cat_offer_value, offer_database[offer_id].bonus_offer_item, offer_database[offer_id].bonus_offer_value, offer_database[offer_id].nonce);
	}


	// This returns an entire list of all offers for a request
	function my_offers (bytes32 req_id) constant returns(bytes32 []){
		return request_offer_mapping[req_id];
	}

	// Return vendor pseudonym id for the offer
	function vendor_details(bytes32 offer_id) constant returns(address){
		return offer_database[offer_id].pseudonym_id;
	}

	function private_pseudo_id_value(bytes32 offer_id) constant returns(bytes32){
		return offer_database[offer_id].private_pseudo_id;
	}

	// I see a fundamental problem here. how do i hide the nonce, if all I need is the offer_id to access it?
	// though if only the requester can access the offer_id then its okay.
	// or maybe encrypt the offer id using the requesters public key so only he can decrypt it

	function nonce_value(bytes32 offer_id) constant returns(bytes32){
		return offer_database[offer_id].nonce;
	}

	function mark_viewed(bytes32 offer_id) {
		OfferInformation storage seen= offer_database[offer_id] ;
		seen.viewed = true ;
		offer_database[offer_id] = seen ;
	}
}