pragma solidity ^0.4.26;

contract RandomProvider {
    function rand(uint256 salt) public view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), now, msg.sender, salt)));
    }
}

contract RewardVault {
    address public owner;

    event Funded(address indexed from, uint256 value);
    event Paid(address indexed to, uint256 value);
    event OwnerChanged(address indexed prev, address indexed next);

    constructor() public payable {
        owner = msg.sender;
        if (msg.value > 0) {
            emit Funded(msg.sender, msg.value);
        }
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function() public payable {
        emit Funded(msg.sender, msg.value);
    }

    function setOwner(address next) public onlyOwner {
        require(next != address(0));
        emit OwnerChanged(owner, next);
        owner = next;
    }

    function pay(address to, uint256 value) public onlyOwner {
        require(to != address(0));
        require(address(this).balance >= value);
        to.transfer(value);
        emit Paid(to, value);
    }

    function balance() public view returns (uint256) {
        return address(this).balance;
    }
}

contract SurveyEngine {
    struct Entry {
        address who;
        bytes32 answerHash;
        uint256 ts;
    }

    Entry[] public entries;
    mapping(address => bool) public submitted;

    RandomProvider public rng;
    RewardVault public vault;

    uint256 public rewardPerWin;
    bool public finalized;
    address public winner;

    event Submitted(address indexed who, bytes32 answerHash);
    event Finalized(address indexed winner, uint256 reward);

    constructor(address _rng, address _vault, uint256 _rewardPerWin) public {
        require(_rng != address(0));
        require(_vault != address(0));
        rng = RandomProvider(_rng);
        vault = RewardVault(_vault);
        rewardPerWin = _rewardPerWin;
        finalized = false;
    }

    function submit(bytes32 answerHash) public {
        require(!finalized);
        require(!submitted[msg.sender]);
        submitted[msg.sender] = true;
        entries.push(Entry(msg.sender, answerHash, now));
        emit Submitted(msg.sender, answerHash);
    }

    function setReward(uint256 v) public {
        require(!finalized);
        rewardPerWin = v;
    }

    function entryCount() public view returns (uint256) {
        return entries.length;
    }

    function finalize(uint256 salt) public {
        require(!finalized);
        require(entries.length > 0);

        uint256 r = rng.rand(salt);
        uint256 idx = r % entries.length;

        winner = entries[idx].who;
        finalized = true;

        if (rewardPerWin > 0 && vault.balance() >= rewardPerWin) {
            vault.pay(winner, rewardPerWin);
        }

        emit Finalized(winner, rewardPerWin);
    }
}

contract Driver {
    SurveyEngine public survey;

    constructor(address _survey) public {
        survey = SurveyEngine(_survey);
    }

    function submit(bytes32 h) public {
        survey.submit(h);
    }

    function finalize(uint256 salt) public {
        survey.finalize(salt);
    }

    function setReward(uint256 v) public {
        survey.setReward(v);
    }

    function entryCount() public view returns (uint256) {
        return survey.entryCount();
    }

    function winner() public view returns (address) {
        return survey.winner();
    }
}

contract Deployer {
    function deploy(uint256 rewardPerWin) public payable returns (address rngAddr, address vaultAddr, address surveyAddr, address driverAddr) {
        RandomProvider rng = new RandomProvider();
        RewardVault vault = (new RewardVault).value(msg.value)();

        SurveyEngine survey = new SurveyEngine(address(rng), address(vault), rewardPerWin);
        vault.setOwner(address(survey));

        Driver driver = new Driver(address(survey));

        return (address(rng), address(vault), address(survey), address(driver));
    }

    function() public payable {}
}

