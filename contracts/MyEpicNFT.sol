// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

// We need some util functions for strings.
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

// We need to import the helper functions from the contract that we copy/pasted.
// import { Base64 } from "libraries/Base64.sol";
import "base64-sol/base64.sol";

contract MyEpicNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // We split the SVG at the part where it asks for the background color.
    string svgPartOne =
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: black; font-family: fantasy; font-size: 26px; }</style><rect width='100%' height='100%' fill='";
    string svgPartTwo =
        "'/><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    // MAGICAL EVENTS.
    event NewEpicNFTMinted(address sender, uint256 tokenId);

    // I create three arrays, each with their own theme of random words.
    // Pick some random funny words, names of anime characters, foods you like, whatever!
    string[] firstWords = [
        "ICON",
        "IDEA",
        "IDOL",
        "JEST",
        "JIVE",
        "JOIN",
        "JOKE",
        "JOYS",
        "JUMP",
        "JUST",
        "KEEN",
        "KEEP",
        "KICK",
        "KIND",
        "KING",
        "KISS",
        "KITE",
        "KNOW",
        "KUDO",
        "LAND",
        "LAST",
        "LAUD",
        "LEAN",
        "LEAP",
        "LIFE",
        "LIFT",
        "LIKE",
        "LIST",
        "LIVE",
        "LONG",
        "LOOK",
        "LORD",
        "LOVE",
        "LUCK",
        "LULL",
        "LUSH",
        "MADE",
        "MAKE",
        "MANY",
        "MATE",
        "MAXI",
        "MEEK",
        "MEGA",
        "MELD",
        "MINT",
        "MINX",
        "MOAT",
        "MOST",
        "MUCH"
    ];

    string[] secondWords = [
        "DARE",
        "DART",
        "DASH",
        "DAWN",
        "DEAL",
        "DEAR",
        "DEED",
        "DEEM",
        "DEEP",
        "DICE",
        "NEED",
        "NEWS",
        "NEXT",
        "NICE",
        "NOTE",
        "ONCE",
        "OOZE",
        "OPEN",
        "OVER",
        "PALS",
        "PEAK",
        "PEEP",
        "PEER",
        "PLAY",
        "PLUS",
        "POET",
        "POSH",
        "PURE",
        "PUSH",
        "RACY",
        "RAPT",
        "READ",
        "REAL",
        "RICH",
        "RISE",
        "ROAR",
        "ROSE",
        "ROSY",
        "DIME",
        "DINE",
        "DING",
        "DOLL",
        "DOPE",
        "DOTE",
        "DOVE",
        "DRAW",
        "DUTY"
    ];
    string[] thirdWords = [
        "HACK",
        "HAIL",
        "HALO",
        "HARD",
        "HEAL",
        "HEAR",
        "HEED",
        "HELL",
        "HELP",
        "HERE",
        "HERO",
        "SAFE",
        "SAGE",
        "SAIL",
        "SANE",
        "SAVE",
        "SEEK",
        "SEEP",
        "SLAY",
        "SLUE",
        "SNUG",
        "SOAR",
        "SOUL",
        "STAR",
        "STAY",
        "STEM",
        "STUN",
        "SWAG",
        "SWAY",
        "TACT",
        "TEST",
        "TIME",
        "TINY",
        "TOOL",
        "TOPS",
        "TRUE",
        "UBER",
        "VAMP",
        "VARY",
        "VENT",
        "VIEW",
        "VIVA",
        "VOTE",
        "WAKE",
        "WALK",
        "WALL",
        "WANT",
        "WARM",
        "WASH",
        "WEAR",
        "WELD",
        "WELL",
        "WHEE",
        "WHIZ",
        "WHOO",
        "WILL",
        "WING",
        "WINK",
        "WINS",
        "HIDE",
        "HIGH",
        "HIKE",
        "HIRE",
        "HOLD",
        "HOLY",
        "HOME",
        "HONE",
        "HOOK",
        "HOOP",
        "HOPE",
        "HOST",
        "HUGE",
        "HUSH"
    ];

    // Get fancy with it! Declare a bunch of colors.
    string[] colors = [
        "#cdb4db",
        "#ffc8dd",
        "#ffafcc",
        "#bde0fe",
        "#a2d2ff",
        "#ccd5ae",
        "#e9edc9",
        "#fefae0",
        "#faedcd",
        "#d4a373",
        "#9a8c98",
        "#fec5bb",
        "#fcd5ce",
        "#fae1dd",
        "#f8edeb",
        "#e8e8e4",
        "#d8e2dc",
        "#ece4db",
        "#ffe5d9",
        "#ffd7ba",
        "#fec89a",
        "#ccff33"
    ];

    constructor() ERC721("JR-3WordsNFT", "JR3WRDS") {
        console.log("This is my awesome NFT contract. Woah!");
    }

    // I create a function to randomly pick a word from each array.
    function pickRandomFirstWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        // I seed the random generator. More on this in the lesson.
        uint256 rand = random(
            string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId)))
        );
        // Squash the # between 0 and the length of the array to avoid going out of bounds.
        rand = rand % firstWords.length;
        return firstWords[rand];
    }

    function pickRandomSecondWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId)))
        );
        rand = rand % secondWords.length;
        return secondWords[rand];
    }

    function pickRandomThirdWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId)))
        );
        rand = rand % thirdWords.length;
        return thirdWords[rand];
    }

    // Same old stuff, pick a random color.
    function pickRandomColor(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("COLOR", Strings.toString(tokenId)))
        );
        rand = rand % colors.length;
        return colors[rand];
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function makeAnEpicNFT() public {
        uint256 newItemId = _tokenIds.current();

        string memory first = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory third = pickRandomThirdWord(newItemId);
        string memory combinedWord = string(
            abi.encodePacked(first," ", second," ",third)
        );

        // Add the random color in.
        string memory randomColor = pickRandomColor(newItemId);
        string memory finalSvg = string(
            abi.encodePacked(
                svgPartOne,
                randomColor,
                svgPartTwo,
                combinedWord,
                "</text></svg>"
            )
        );

        // Get all the JSON metadata in place and base64 encode it.
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        // We set the title of our NFT as the generated word.
                        combinedWord,
                        '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                        // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        // Just like before, we prepend data:application/json;base64, to our data.
        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("\n--------------------");
        console.log(finalTokenUri);
        console.log("--------------------\n");

        _safeMint(msg.sender, newItemId);

        // Update your URI!!!
        _setTokenURI(newItemId, finalTokenUri);

        _tokenIds.increment();
        console.log(
            "An NFT w/ ID %s has been minted to %s",
            newItemId,
            msg.sender
        );

        // EMIT MAGICAL EVENTS.
        emit NewEpicNFTMinted(msg.sender, newItemId);
    }
}
