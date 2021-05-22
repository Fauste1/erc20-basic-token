pragma solidity ^0.8.0;

/**
* @dev Basic token contract solely for the purpose of learning Solidity & practice
* @dev assuming that safemath library is no longer needed as solidity v8 and above checks for overflows by default
*
* The following code was inspired by (and often copy-pasted from) the latest OpenZeppelin repository https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol
* 
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

    constructor (string memory name_, string memory symbol_, uint8 decimals_, uint256 _initialMint) {
        _name = name_;
        _symbol = symbol_;
        _decimals = decimals_;
        _mint(msg.sender, _initialMint);

        // set the owner of this contract ?
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

    /**
    * @dev Transfers a specified amount of tokens (`value`) from msg.sender to a recipient (`to`)
    */
    function transfer(address to, uint256 value) public virtual override returns (bool success) {
        _transfer(msg.sender, to, value);
        return true;
    }
    
    /**
    * @dev transfers a given amount of the token from a specified address ('from') to a specified recipient ('to')
    * The internal _approve function emits an {Approval} event indicating the updated allowance. This is not required by the EIP.
    */
    function transferFrom(address from, address to, uint256 value) public virtual override returns (bool success) {
        uint256 _currentAllowance = _allowed[from][msg.sender];
        require(_currentAllowance >= value, "ERC20: Transfer amount exceeds allowance");
        
        _transfer(from, to, value);
        
        // This is implied valid based on the require earlier in the function
        unchecked {
            _approve(from, msg.sender, _currentAllowance - value);
        }

        return true;
    }
    
    /**
    * @dev Set a new allowance for a spender
    */
    function approve(address spender, uint256 value) public virtual override returns (bool success) {
        _approve(msg.sender, spender, value);
        return true;
    }

    /**
    * @dev Returns current allowance for a particular spender of a particular owner account
    */
    function allowance(address owner, address spender) public virtual override view returns (uint256 remaining) {
        return _allowed[owner][spender];
    }

    /**
    * @dev Atomically increases allowance for a particular spender of a msg.sender account
    */
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool success) {
        // Might want to consider reverting if msg.sender == spender (would this save gas?)
        _approve(msg.sender, spender, _allowed[msg.sender][spender] + addedValue);
        return true;
    }

    /**
    * @dev Atomically decreases allowance for a particular spender of a msg.sender account
    */
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool success) {
        _approve(msg.sender, spender, _allowed[msg.sender][spender] - subtractedValue);
        return true;
    }

    /**
    * @dev Internal function to handle transfers of given amount of the token between two addresses
    */
    function _transfer(address from, address to, uint amount) internal virtual {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        uint256 senderBalance = _balances[from];
        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[from] -= amount;
        }
        _balances[to] += amount;

        emit Transfer(from, to, amount);
    }

    /**
    * @dev Internal function to handle adjust allowances for a given spender of a given owner account
    */
    function _approve(address owner, address spender, uint value) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        
        _allowed[owner][spender] = value;
        emit Approval(owner, spender, value);
    }

    /**
    * @dev Internal function to mint new tokens and transfer them to a given account. Increases the total supply.
    */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);
    }

    /**
    * @dev Internal function to burn existing tokens of a given account. Decreases the total token supply.
    */
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
        }
        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);
    }
}