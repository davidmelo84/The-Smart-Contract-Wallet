# The-Smart-Contract-Wallet
Project The Smart Contract Wallet with Solidity


Explicação do Código
Proprietário: O endereço do proprietário é definido no construtor e só pode ser alterado por um grupo de guardiões.
Recebimento de Fundos: A função receive() permite que o contrato receba Ether.
Transferência de Fundos: A função transfer() permite ao proprietário transferir fundos. A função transferWithAllowance() permite que pessoas autorizadas transfiram fundos.
Permissões: O proprietário define permissões usando setAllowance(). As permissões são usadas na função transferWithAllowance().
Recuperação de Propriedade: Guardiões podem propor e votar em um novo proprietário. A função voteForNewOwner() altera o proprietário quando o número necessário de votos é alcançado.

Testando o Contrato
Para testar o contrato:

Implemente o contrato: Use um ambiente de desenvolvimento como Remix IDE.
Adicione Guardiões: Use a função addGuardian para adicionar endereços de guardiões.
Proponha e Vote: Use proposeNewOwner e voteForNewOwner para alterar o proprietário.
Teste Transferências e Permissões: Use transfer, transferWithAllowance, e setAllowance para verificar as funcionalidades de transferência e permissões.
