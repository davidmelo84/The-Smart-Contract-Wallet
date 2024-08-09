// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract SmartWallet {
    address public owner;
    mapping(address => uint256) public allowances;
    address[] public guardians;
    mapping(address => bool) public guardianVotes;
    address public proposedOwner;
    uint256 public voteCount;
    uint256 public requiredVotes = 3;

    // Evento para logar transferências
    event Transfer(address indexed to, uint256 amount);
    // Evento para logar mudanças de propriedade
    event OwnershipTransferred(address indexed newOwner);

    constructor() {
        owner = msg.sender;  // Define o proprietário como o criador do contrato
    }

    // Permite que o contrato receba Ether
    receive() external payable {}

    // Função para transferir fundos, apenas o proprietário pode chamar
    function transfer(address payable _to, uint256 _amount) external {
        require(msg.sender == owner, "Somente o proprietário pode transferir fundos");
        require(address(this).balance >= _amount, "Saldo insuficiente");
        (bool success, ) = _to.call{value: _amount}("");
        require(success, "Falha na transferência");
        emit Transfer(_to, _amount);
    }

    // Permitir que o proprietário defina permissões
    function setAllowance(address _spender, uint256 _amount) external {
        require(msg.sender == owner, "Somente o proprietário pode definir permissões");
        allowances[_spender] = _amount;
    }

    // Função para transferir fundos com permissões
    function transferWithAllowance(address payable _to, uint256 _amount) external {
        uint256 allowedAmount = allowances[msg.sender];
        require(allowedAmount >= _amount, "Permissão insuficiente");
        allowances[msg.sender] -= _amount;
        (bool success, ) = _to.call{value: _amount}("");
        require(success, "Falha na transferência");
        emit Transfer(_to, _amount);
    }

    // Adiciona um guardião (só o proprietário pode adicionar)
    function addGuardian(address _guardian) external {
        require(msg.sender == owner, "Somente o proprietário pode adicionar guardiões");
        guardians.push(_guardian);
    }

    // Propor um novo proprietário (só um guardião pode propor)
    function proposeNewOwner(address _newOwner) external {
        require(isGuardian(msg.sender), "Somente um guardião pode propor um novo proprietário");
        proposedOwner = _newOwner;
        voteCount = 1;
        guardianVotes[msg.sender] = true;
    }

    // Votar para o novo proprietário (só um guardião pode votar)
    function voteForNewOwner() external {
        require(isGuardian(msg.sender), "Somente um guardião pode votar");
        require(proposedOwner != address(0), "Nenhum novo proprietário proposto");
        require(!guardianVotes[msg.sender], "Você já votou");

        guardianVotes[msg.sender] = true;
        voteCount++;

        if (voteCount >= requiredVotes) {
            owner = proposedOwner;
            proposedOwner = address(0);
            voteCount = 0;
            clearGuardianVotes();
            emit OwnershipTransferred(owner);
        }
    }

    // Verificar se um endereço é um guardião
    function isGuardian(address _guardian) internal view returns (bool) {
        for (uint256 i = 0; i < guardians.length; i++) {
            if (guardians[i] == _guardian) {
                return true;
            }
        }
        return false;
    }

    // Limpar votos de guardiões
    function clearGuardianVotes() internal {
        for (uint256 i = 0; i < guardians.length; i++) {
            guardianVotes[guardians[i]] = false;
        }
    }
}

