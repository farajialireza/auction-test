// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Auction {
    mapping(address => uint) biddersData;
    uint highestBidAmount;
    address highestBidAddressVar;
    uint startTime = block.timestamp;
    uint endTime;
    bool auctionEnded = false;
    address owner;

    constructor() {
        owner = msg.sender;
    }

    // put new bid
    function putBid() public payable {
        // map update mishe va age user khast mablaghi ezafe kone bayad be meghdari ke alan tooye map hast ezafe beshe
        uint calculateAmount = biddersData[msg.sender] + msg.value;

        // check if auction session not ended
        require(auctionEnded == true, "Auction is ended");
        require(block.timestamp <= endTime, "Auction is ended");

        // verify value is not zero
        require(msg.value > 0, "Bid amount can not be zero");

        // check if bid is higesr than highest bid
        require(msg.value > highestBidAmount, "Bid should be higher than highest bid");

        // update user bid in biddersData map
        biddersData[msg.sender] = calculateAmount;

        // update highest bid amount & highest bidder address
        highestBidAmount = calculateAmount;
        highestBidAddressVar = msg.sender;
    }

    // get contract balance (just for testing)
    function getBiddersBid(address _address) public view returns(uint) {
        return biddersData[_address];
    }

    // get highest bid amount
    function highestBid() public view returns(uint) {
        return highestBidAmount;
    }

    // highest bidder address
    function highestBidderAddressFunc() public view returns(address) {
        return highestBidAddressVar;
    }

    // upt end time
    function putEndTime(uint _endTime) public {
        endTime = _endTime;
    }

    // close auction
    function endAuction() public {
        if (msg.sender == owner) {
            auctionEnded = true;
        }
    }

    // withdraw bid
    function withdrawBid(address payable _address) public {
        // check if _address exists in our data
        if (biddersData[_address] > 0) {
            _address.transfer(biddersData[_address]);
        }
    }
}