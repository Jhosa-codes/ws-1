# ws-1

Primeiro projeto do workspace: reimaginação 2.5D de Pokémon Crystal com
combate em tempo real e sem modo JRPG.

## Visão

- 2.5D side-view
- Combate em tempo real (ações imediatas, sem turnos)
- Sem encontros aleatórios e sem status do JRPG
- Colecionar, evoluir e avançar no mundo

## Estrutura

```
ws-1/
├── README.md          # Este arquivo
├── AGENTS.md          # Instruções de desenvolvimento
├── .gitignore         # Arquivos ignorados pelo Git
├── docs/
│   └── PRD.md         # Documento de requisitos do produto
└── src/               # Código-fonte
```

## Como começar

1. `cd /c/Users/Joao/Documents/ws-1`
2. Ler `docs/PRD.md` para entender o escopo.
3. Decidir stack (Godot, Phaser, Unity ou outra).
4. Scaffold com a estrutura de pastas e engine project.
5. Fase 1: movimentação + um inimigo simples.
6. Commit: `git add -A && git commit -m "<descricao>"`.

## Status

- [ ] Definir stack e direção 2.5D
- [ ] Scaffold do projeto
- [ ] Fase 1: mini-loop
- [ ] Fase 2: playable
