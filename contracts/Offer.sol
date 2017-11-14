pragma solidity ^0.4.4;
import "./Request.sol";


contract Offer{
	
	Request req;
	struct OfferInformation{
		bytes32 offer_transaction_id ;
		bytes32 request_id ;
		bytes32 activity_type ;
		//bytes validity_timestamp ;
		address pseudonym_id ;
		bytes32 session_key ;
		bytes32 cat_offer_value ;
		bytes32 bonus_offer_value ;
		bytes32 nonce ;
		bytes32 private_pseudo_id ;
	}

	// mapping between offer transaction id and offer information
	struct Mapper{
		mapping(bytes32 => OfferInformation) offer_list;
		OfferInformation[] my_offers ;
	}

	// mapping of request transaction ids and the offers associated with them
	mapping ( bytes32 => Mapper) nmap;

	// contains every offer ever made
	mapping(bytes32 => OfferInformation) public offer_database;

	// whenever an offer is made, offer information struct is generated. 
	// we check if request for that offer exists 
	// if the request for that transaction exists, we create a map which contains all offers for that request
	// structure is as follows: Request => [map of offers for that request]
	function make_offer ( bytes32 offer_id, bytes32 req_id, bytes32 sess_key , bytes32 cat_value, 
							bytes32 bonus_value , bytes32 nonce_info , bytes32 private_pseudonym_id){
							
							OfferInformation  memory vendor = OfferInformation({ offer_transaction_id: offer_id, request_id: req_id, activity_type: "offer", pseudonym_id: msg.sender, session_key: sess_key, cat_offer_value : cat_value , bonus_offer_value: bonus_value,
							nonce: nonce_info, private_pseudo_id: private_pseudonym_id});

							//if(!request_database[req_id].isEntity) throw;
							bool check  = req.get_isEntity(req_id);
							
							require(check);

							// extracts existing offers for that request
							Mapper storage offer_extract = nmap[req_id];


							// adds new offer to that mapping of offers => offer information
							offer_extract.offer_list[offer_id] = vendor ;

							offer_extract.offer_list[offer_id].offer_transaction_id = offer_id;
							offer_extract.offer_list[offer_id].request_id = req_id;
							offer_extract.offer_list[offer_id].activity_type = "offer";
							offer_extract.offer_list[offer_id].pseudonym_id = msg.sender;
							offer_extract.offer_list[offer_id].session_key =  sess_key;
							offer_extract.offer_list[offer_id].cat_offer_value =  cat_value;
							offer_extract.offer_list[offer_id].bonus_offer_value =  bonus_value;
							offer_extract.offer_list[offer_id].nonce =  nonce_info;
							offer_extract.offer_list[offer_id].private_pseudo_id = private_pseudonym_id;


							offer_extract.my_offers.push(vendor);



							// adds the updated offer list back to nmap
							nmap[req_id] = offer_extract ;


							offer_database[offer_id].offer_transaction_id = offer_id;
							offer_database[offer_id].request_id = req_id;
							offer_database[offer_id].activity_type = "offer";
							offer_database[offer_id].pseudonym_id = msg.sender;
							offer_database[offer_id].session_key =  sess_key;
							offer_database[offer_id].cat_offer_value =  cat_value;
							offer_database[offer_id].bonus_offer_value =  bonus_value;
							offer_database[offer_id].nonce =  nonce_info;
							offer_database[offer_id].private_pseudo_id = private_pseudonym_id;
		}

	function get_offer_information(bytes32 offer_id) constant returns(bytes32){
		// input here is an offer id
		// with the offer id 
		return offer_database[offer_id].request_id;
	}

	function get_offer_for_request(bytes32 request) constant returns(bytes32){

		return nmap[request].my_offers[0].offer_transaction_id;
	}


}