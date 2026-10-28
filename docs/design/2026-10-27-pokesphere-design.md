# Design — PokéSphere (ws-1)

Data: 2026-10-27
Status: revisado pelo builder, respostas do dono incorporadas — aguardando aprovação final

## Intent (o porquê)

Reimaginar Pokémon Crystal em **2.5D side-view** com **combate em tempo real
híbrido**, **sem modo JRPG**. O Crystal original é turno a turno e top-down;
esta versão é mais ação e acessível, mantendo a alma de colecionar/evoluir
mas tirando o jogador do menu de turnos.

## Goals

- Mundo 2.5D side-view navegável.
- Combate em tempo real **híbrido**: o jogador **É o Pokémon** — corre e
  desvia com ele; o Pokémon **ataca sozinho** (IA por cooldown).
- Reaproveitar os dados do Crystal (tipos, stats, learnsets) convertidos pra
  JSON.
- MVP jogável: 1 área, 1 inimigo, 1 tipo, 1 status, vencer por HP.

## Non-goals

- Combate por turnos.
- Encontros aleatórios / tela de batalha separada.
- Grind de nível.
- Multijogador.
- Vista isométrica.
- Captura (fora do MVP — só vencer por HP).

## Anti-goals (o que tornaria um fracasso mesmo se funcionar)

- Combate que seja "menu de turnos com passos extras" — tem que sentir ação.
- Mundo que seja só um corredor sem escolha.
- Combate tão complexo que não dá pra balancear.

## Constraints

- Desenvolvedor iniciante (Joao).
- Engine: **Godot 4**. Linguagem: **GDScript**.
- Prazo **flexível** (~4 semanas estimativa) — prioriza o que ficar bom, não
  o que fecha no prazo.
- Arte: **placeholder** no MVP (o Joao gera/procura sprites depois).
- Reaproveitar dados do Crystal (`pokecrystal-master`) onde fizer sentido.

## Approaches (decidido na conversa)

| Decisão | Opções consideradas | Escolhido | Por quê |
|---|---|---|---|
| Direção 2.5D | side-view vs isométrico | **side-view** | Mais simples pro MVP; câmera ortográfica fácil |
| Quem é o jogador | o Pokémon / treinador separado | **o Pokémon** | Controle direto, câmera simples, bate com side-view |
| Controle de combate | híbrido / auto / direto | **híbrido** | Ação sem complexidade de controlar cada ataque |
| Escopo do MVP | enxuto / ambicioso | **enxuto** | Jogável rápido |
| Captura no MVP | sim / não | **não** (só HP) | Simplifica o combate; captura vem depois |
| Arte | placeholder / interna | **placeholder** | Sem dependência externa no MVP |

## Como (o que foi decidido)

### 2.5D side-view no Godot
- Cena 3D com **câmera ortográfica** e rotação leve (`camera_rotation.y`),
  sprites 2D como texturas — dá o visual 2.5D.
- **Risco técnico:** misturar cena 3D ortográfica com tilemap 2D é frágil.
  **Validar com um spike pequeno antes de prometer** a abordagem completa.
- Mundo: tilemap 2D com parallax para profundidade.

### Combate híbrido em tempo real (o jogador É o Pokémon)
- **Loop de tick** (não turno): cada Pokémon age em cooldown.
- **Jogador controla (é o seu Pokémon):** movimentação esquerda/direita +
  **esquiva** (um botão). A esquiva dá **i-frames** (invencível numa janela
  curta) com cooldown.
- **IA do Pokémon inimigo:** ataca sozinho em cooldown; escolhe ataque pela
  tabela de learnset.
- **O que leva dano:** o Pokémon do jogador (você). HP compartilhado é só a
  barra do seu Pokémon vs a do inimigo.
- **Status** (veneno, queimadura): dano por tick.
- **Vencer:** zerar o HP do inimigo. (Captura fica pra depois do MVP.)

### Fórmula de dano (decisão do builder → simplificada pro MVP)
- `dano = power × (atk_defensor / (defensor + 1)) × fator_tipo × rand(0.85–1.0)`
- `fator_tipo` vem da tabela tipo×tipo. No MVP com 1 tipo, a tabela é mínima.
- A fórmula completa do Crystal entra na Fase 2, não no MVP.

### Dados (reaproveitando o Crystal)
- `data/pokemon.json` — array de objetos: `id, name, types[],
  stats{hp,atk,def,spd,sat,sdf}, learnset[]`. (`base_exp`/`growth_rate` ficam
  no schema mas **não usados no MVP**.)
- `data/types.json` — resistência tipo×tipo (reduzida pro MVP).
- `data/moves.json` — ataques: `name, type, power, effect, cooldown`.
- Converter do `base_stats/*.asm` e `moves/effects.asm` do Crystal.

### Arquitetura de cenas (Godot)
```
World (cena 3D, câmera ortográfica + tilemap)
├── PlayerPokemon (sprite 2.5D, move + dodge com i-frames)
└── EnemyPokemon (sprite 2.5D, IA de combate por cooldown)
BattleState (machine: idle/engage/flee/win/lose)
TypeSystem (resistência)
PokemonData (loader de JSON)
```

## O que fica pro builder

- Pokémon e ataque específicos pro MVP (sugestão: **Pikachu + ThunderShock**
  vs 1 inimigo de tipo fraco, ex: um tipo Terra sem resistência).
- Tamanho exato da área 1 e quantas telas de parallax.
- Detalhes da UI (barras de HP, indicador de cooldown da esquiva).
- Ajuste fino da fórmula de dano depois de playtest.

## Próximos passos

1. Aprovação final do dono deste design doc.
2. `superpowers:writing-plans` para detalhar o plano de implementação.
3. Depois do plano aprovado: scaffold do Godot (Etapa 3).
