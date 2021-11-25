pragma solidity 0.8.7;

contract Strategy {
    address owner;
    uint rewardPercent;

    struct StrategyItem {
        address token;
        uint256 stake;
    }
    
    uint256 strategyCount;
    mapping(uint256 => StrategyItem[]) strategies;
    mapping(uint256 => bytes32) strategyName;
    mapping(address => uint256[]) strategyOwners;
    mapping(uint256 => mapping(address => bool)) strategyJoiners;

    event OwnerTransfered(address indexed prevOwner, address indexed newOwner);
    event RewardSet(uint prevPercet, uint newPercent);
    event JoinStrategy(address joiner, uint256 strategyIndex, uint256 joinAt);
    event ExitStrategy(address joiner, uint256 strategyIndex, uint256 joinAt);
    event TransferStrategy(uint256 _strategyIndex, address _from, address _to);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "Ownable: only owner can call this fucntion");
        _;
    }

    function setOwner(address _newOwner) public onlyOwner() {
        require(_newOwner != address(0), "Invalid address");

        emit OwnerTransfered(owner, _newOwner);
        owner = _newOwner;
    }

    function setReward(uint _newPercent) public onlyOwner() {
        emit RewardSet(rewardPercent, _newPercent);
        rewardPercent = _newPercent;
    }

    function createStrategy(address[] calldata _tokens, uint256[] calldata _stakings, bytes32 _name) public {
        require(_tokens.length == _stakings.length && _tokens.length > 0, "Insufficient data to create strategy");

        for(uint i = 0; i < _tokens.length; i++) {
            strategies[strategyCount].push(StrategyItem(_tokens[i], _stakings[i]));
        }

        strategyName[strategyCount] = _name;
        strategyOwners[msg.sender] = [strategyCount];
        strategyCount++;
    }

    function joinStrategy(uint256 _strategyIndex) public {
        require(!strategyJoiners[_strategyIndex][msg.sender], "Joined already");

        strategyJoiners[_strategyIndex][msg.sender] = true;

        emit JoinStrategy(msg.sender, _strategyIndex, block.timestamp);
    }

    function exitStrategy(uint256 _strategyIndex) public {
        require(strategyJoiners[_strategyIndex][msg.sender], "You did not join before");

        strategyJoiners[_strategyIndex][msg.sender] = false;

        emit ExitStrategy(msg.sender, _strategyIndex, block.timestamp);
    }

    function transferStrategy(uint256 _strategyIndex, address _to) public {
        require(msg.sender != _to, "Same user");

        require(strategyJoiners[_strategyIndex][msg.sender], "Strategy: You are not the owner of this strategy");

        uint selInd = 0;
        uint[] memory indList = strategyOwners[msg.sender];
        for(uint i = 0; i < indList.length; i++) {
            if(indList[i] == _strategyIndex) {
                selInd = i;
                break;
            }
        }

        delete indList[selInd];
        strategyOwners[msg.sender] = indList;

        strategyOwners[_to].push(_strategyIndex);

        emit TransferStrategy(_strategyIndex, msg.sender, _to);
    }
}
