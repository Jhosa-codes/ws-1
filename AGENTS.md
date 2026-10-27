# ws-1

Workspace do primeiro projeto do usuário (Joao). Repositório em branco por
conta própria: só estrutura base (`README.md`, `.gitignore`) e Git/GitHub
ligados. Nenhum código de aplicação ainda.

## Início

1. `cd /c/Users/Joao/Documents/ws-1`
2. Definir escopo (tipo de projeto, linguagem, estrutura de pastas).
3. Editar `README.md` com objetivo, estrutura e status.
4. Commitar: `git add -A && git commit -m "<descricao>"`.

## Ambiente de desenvolvimento

- Git + GitHub CLI já configurados (conta `Jhosa-codes`).
- Remoto `upstream`: `https://github.com/Jhosa-codes/ws-1.git`.
- Nenhum build/test/lint definido ainda — criar conforme a tecnologia
  escolhida (package.json, pyproject.toml, Makefile, etc.).

## Convenções

- `README.md` é a fonte de verdade: objetivo, estrutura e status.
- Mensagens de commit em imperative curto: "Add feature", "Fix bug".
- Dependências/artefatos ignorados via `.gitignore`
  (`node_modules/`, `__pycache__/`, `dist/`, `*.log`).
- Notas de acompanhamento no Obsidian (`Projetos/*.md`).

## Pitfalls

- `README.md` linha 12: `Arquivosagr/` → corrigir para `Arquivos/`.
- `.gitignore` ignora `node_modules/` e `dist/` — se o projeto usar Node/JS
  ou outra linguagem com output de build, confirmar se ignora demais ou
  falta algo.
