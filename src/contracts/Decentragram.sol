pragma solidity ^0.5.0;

contract Decentragram {
    string public name = "Decentragram";

    // store images

    uint256 public imageCount = 0;

    mapping(uint256 => Image) public images;

    struct Image {
        uint256 id;
        string hash;
        string description;
        uint256 tipAmount;
        address payable author;
    }

    event ImageCreated(
        uint256 id,
        string hash,
        string description,
        uint256 tipAmount,
        address payable author
    );

    event ImageTipped(
        uint256 id,
        string hash,
        string description,
        uint256 tipAmount,
        address payable author
    );

    // Create Images

    function uploadImage(string memory _imgHash, string memory _description)
        public
    {
        require(bytes(_imgHash).length > 0);
        require(bytes(_description).length > 0);
        require(msg.sender != address(0x0));

        imageCount++;

        images[imageCount] = Image(
            imageCount,
            _imgHash,
            _description,
            0,
            msg.sender
        );

        emit ImageCreated(imageCount, _imgHash, _description, 0, msg.sender);
    }

    function tipImageOwner(uint256 _id) public payable {
        require(_id > 0 && _id <= imageCount);

        // Fetch the image
        Image memory _image = images[_id];
        address payable _author = _image.author;

        // Pay author by sending them ether
        address(_author).transfer(msg.value);

        _image.tipAmount = _image.tipAmount + msg.value;

        images[_id] = _image;

        emit ImageTipped(
            _id,
            _image.hash,
            _image.description,
            _image.tipAmount,
            _author
        );
    }
}
