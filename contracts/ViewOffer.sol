pragma solidity ^0.4.4;
import "./Request.sol";
import "./Offer.sol";


contract ViewOffer{
	
	Offer offer_mark ;

	struct ViewInfo{
		bytes32 view_transaction_id ;
		bytes32 offer_id ;
		bytes32 linking_id ;
		bytes32 activity_type ;
		bytes32 verify ;
		bytes32 proof_of_view ;
		bytes32 private_linking_id ;
	}
	
	mapping(bytes32 => ViewInfo) public view_database;

	event ViewGoods ( bytes32 view_transaction_id, bytes32 offer_id);

	function view_offer(bytes32 view_id, bytes32 offer_details, bytes32 linking_details, bytes32 verify_details, bytes32 proof_of_view_details,	
	 bytes32 private_linking_id_details){

		view_database[offer_details] = ViewInfo({view_transaction_id: view_id, offer_id: offer_details, linking_id: linking_details, activity_type: "view", verify: verify_details, proof_of_view: proof_of_view_details, private_linking_id: private_linking_id_details});

		// Marks an offer as viewed in thew offer database
		offer_mark.mark_viewed(offer_details);
		ViewGoods (view_id, offer_details);
	}


}