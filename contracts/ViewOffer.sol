pragma solidity ^0.4.4;
import "./Request.sol";
import "./Offer.sol";


contract ViewOffer{
	struct ViewInfo{
		bytes32 view_id ;
		bytes32 offer_id ;
		string linking_id ;
		bytes32 activity_type ;
		string signed_1;
		bytes32 request_id_1;
		string signed_2;
		bytes32 request_id_2;
	}
	
	mapping(bytes32 => ViewInfo) public view_database;

	event ViewEvent(bytes32 view_id, bytes32 offer_id);

	function createView(bytes32 view_id, bytes32 offer_id, string linking_id, string signed_1, bytes32 request_id_1, string signed_2, bytes32 request_id_2){
		view_database[offer_id] = ViewInfo({view_id: view_id, offer_id: offer_id, linking_id: linking_id, activity_type: "view", signed_1: signed_1, request_id_1: request_id_1, signed_2: signed_2, request_id_2: request_id_2});
		ViewEvent (view_id, offer_id);
	}

	function getViewDetails(bytes32 offer_id) constant returns(string, bytes32, string, bytes32) {
		return (view_database[offer_id].signed_1, 
		view_database[offer_id].request_id_1, 
		view_database[offer_id].signed_2, 
		view_database[offer_id].request_id_2);
	} 
}