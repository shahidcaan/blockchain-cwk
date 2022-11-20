// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "./TweetTemplate.sol";
/**
 * @title Twitter Contract
 * @dev Store & retrieve value in a variable
 */
contract TwitterContract {

     Tweet[] private allTweets;

    event AddTweet(address recipient, uint tweetId);
    event DeleteTweet(uint tweetId, bool isDeleted);


    // Mapping of Tweet id to the wallet address of the user
    mapping(uint256 => address) tweetToOwner;


    // Method to add a new Tweet, can be use from the front end side
    function addTweet(string memory tweetText, bool isDeleted) external {
        uint tweetId = allTweets.length;
        allTweets.push(Tweet(tweetId, msg.sender, tweetText, isDeleted));
        tweetToOwner[tweetId] = msg.sender;
        emit AddTweet(msg.sender, tweetId);
    }

    // Method to get all the Tweets
    function getAllTweets() external view returns (Tweet[] memory) {
        Tweet[] memory temporary = new Tweet[](allTweets.length);
        uint counter = 0;
        for(uint i=0; i<allTweets.length; i++) {
            if(allTweets[i].isDeleted == false) {
                temporary[counter] = allTweets[i];
                counter++;
            }
        }

        Tweet[] memory result = new Tweet[](counter);
        for(uint i=0; i<counter; i++) {
            result[i] = temporary[i];
        }
        return result;
    }

    // Method to get only your Tweets
    function getMyTweets() external view returns (Tweet[] memory) {
        Tweet[] memory temporary = new Tweet[](allTweets.length);
        uint counter = 0;
        for(uint i=0; i<allTweets.length; i++) {
            if(tweetToOwner[i] == msg.sender && allTweets[i].isDeleted == false) {
                temporary[counter] = allTweets[i];
                counter++;
            }
        }

        Tweet[] memory result = new Tweet[](counter);
        for(uint i=0; i<counter; i++) {
            result[i] = temporary[i];
        }
        return result;
    }

    // Method to Delete a Tweet
    function deleteTweet(uint tweetId, bool isDeleted) external {
        if(tweetToOwner[tweetId] == msg.sender) {
            allTweets[tweetId].isDeleted = isDeleted;
            emit DeleteTweet(tweetId, isDeleted);
        }
    }

}
