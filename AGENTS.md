# PokéSphere (ws-1)

Reimaginação 2.5D side-view de Pokémon Crystal com combate em tempo real
(híbrido: o jogador É o Pokémon, move/desvia; o Pokémon ataca sozinho). Sem
modo JRPG. Engine: Godot 4.7, GDScript. O design está em
`docs/design/2026-10-27-pokesphere-design.md`.

## Início

1. Abrir no editor Godot: importar o projeto em
   `C:/Users/Joao/Documents/ws-1` e pressionar F5 (cena `scenes/Main.tscn`).
2. Controles da playtest: **A/D** movem o Pikachu, a batalha é automática.
3. O motor está em `C:/Users/Joao/tools/godot/Godot.exe` (não está no PATH).

## Build / test / run

O Godot não está no PATH — use o caminho completo (`GODOT` abaixo).

```bash
GODOT="C:/Users/Joao/tools/godot/Godot.exe"
PROJ="C:/Users/Joao/Documents/ws-1"

# Testes da lógica (headless, exit 0 = tudo passa):
"$GODOT" --headless --path "$PROJ" --script res://tests/test_runner.gd

# Rodar a playtest headless por N frames (sem janela):
"$GODOT" --headless --path "$PROJ" --quit-after 300
```

No editor: F5 roda `scenes/Main.tscn`. Fechar a janela ou F8 para parar.

## Estrutura

```
project.godot          config, autoloads (TypeSystem, Battle), input map
scenes/Main.tscn       cena inicial (root: Node2D + scripts/main.gd)
scripts/
  type_system.gd       autoload: efetividade de tipos + fórmula de dano
  battle.gd            autoload: resolve_attack (integra tipo + dano)
  pokemon.gd           classe PokemonData (stats, HP, moves)
  main.gd              cena principal: carrega dados, batalha 2D demo
data/
  pokemon.json         Pikachu + Squirtle (stats reais do Crystal)
  types.json           matriz de efetividade tipo x tipo
  moves.json           ThunderShock, Water Gun
tests/test_runner.gd   testes headless da lógica
```

## Convenções

- GDScript 4.x. `const`/`@onready` pra valores fixos; tipagem explícita em
  funções públicas.
- Dados são a fonte de verdade: novos Pokémon/ataques vão em `data/*.json`,
  não hardcodados em script.
- Lógica testável vive em `scripts/*.gd` puro (sem nós), não na cena. A cena
  só monta o visual e chama a lógica.
- Autoloads (`TypeSystem`, `Battle`) para serviços globais; evite referenciar
  autoloads por nome dentro de scripts carregados via `--script` (não estão
  registrados no parse — instancie por `preload`).
- Commit em imperative curto: "Add Water Gun move", "Fix dodge cooldown".

## Pitfalls

- `Array[String]` não aceita o array cru do `JSON.parse_string` (devolve
  `Array` não-tipado) — declare campos de lista como `Array` solto.
- `JSON.parse_string()` devolve os **dados** (ou `null` no erro), não o código
  de erro. Cheque `parsed == null`; `JSON.get_error()` não existe no 4.7.
- `class_name` de um script não está disponível em autoloads no parse — use
  `const X = preload("res://...")` pra tipar.
- `:=` falha quando o RHS é `Variant` (ex.: `meu_array[0]` de um JSON) — use
  `var x = ...` sem os dois-pontos.
- A abordagem 2.5D (cena 3D ortográfica + tilemap) é o próximo spike; o MVP
  roda em 2D side-view (Node2D) como base. Ver design doc, seção "Como".
