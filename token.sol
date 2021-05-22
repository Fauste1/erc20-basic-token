pragma solidity ^0.8.0;

/**
* @dev Basic token contract solely for the purpose of learning Solidity & practice
* @dev assuming that safemath library is no longer needed as solidity v8 and above checks for overflows by default
*/

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address _owner) external view returns (uint256 balance);
    function transfer(address _to, uint256 _value) external returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
    function approve(address _spender, uint256 _value) external returns (bool success);
    function allowance(address _owner, address _spender) external view returns (uint256 remaining);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

interface IERC20Metadata is IERC20 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
}

contract EBT is IERC20, IERC20Metadata {
    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowed;
    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

    constructor (string memory name_, string memory symbol_, uint8 decimals_) {
        _name = name_;
        _symbol = symbol_;
        // custom added decimals here
        _decimals = decimals_;
        
        // Call the minting function and mint the tokens
        // set the owner of this contract
    }

    /**
    * @dev Returns the name of the token
    */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
    * @dev Returns the symbol of the token
    */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
    * @dev Returns the number of decimals of the token
    */
    function decimals() public view virtual override returns (uint8) {
        return _decimals;
    }

    /**
    * @dev Total number of tokens in existence
    */
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    /**
    * @dev Current balance of owner   
    */
    function balanceOf(address owner) public view virtual override returns (uint256 balance) {
        return _balances[owner];
    }

    function transfer(address to, uint256 value) public virtual override returns (bool success) {
        // Check with the OpenZeppelin docs the first argument (sender)
        _transfer(msg.sender, to, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public virtual override returns (bool success) {
        _transfer(from, to, value);

        // implement the rest of the function

        return true;
    }

    function approve(address spender, uint256 value) public virtual override returns (bool success) {
        _approve(msg.sender, spender, value);
        return true;
    }

    function allowance(address owner, address spender) public virtual override view returns (uint256 remaining) {
        return _allowed[owner][spender];
    }

    // Declare and implement increaseAllowance function

    // Declare and implement decreaseAllowance function

    function _transfer(address sender, address recipient, uint amount) internal virtual {
        // Implement the _transfer function logic
    }

    function _approve(address owner, address spender, uint value) internal virtual {
        // Implement the _approve function logic
    }

    // Declare and implement _mint function


    // Declare and implement _burn function
}