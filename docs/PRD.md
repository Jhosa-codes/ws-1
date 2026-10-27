# PRD — ws-1 (PokéSphere)

## Visão
Reimagens 2.5D da Pokémon Crystal com **combate em tempo real** e **sem
modo JRPG** (sem encontros aleatórios, sem turnos, sem progressão por
nível pesada). O jogador avança no mundo, enfrenta monstros em ação
imediata e coleciona/evolui.

## Pilares de design
1. **Ação imediata** — o combate começa em qualquer momento, não após um
   menu/desvio.
2. **Coleção** — capturar e evoluir pelos gostos, não por level-grind.
3. **Sem JRPG** — nunca se perde tempo com métrica de "próximo nível";
   o desafio vem da habilidade de combate e escolhas, não de escalada de
   nível.
4. **2.5D** — world plane 2D, profundidade/sombras via 3D leves ou
   sprites animados (side-view recomendo para começar).

## Ouvidos (em escopo)
- Navegação 2.5D em área aberta.
- Pokémon selvagens que aparecem visíveis no mapa (não método de
  chance/aleatório).
- Batalha real-time: dodge, ataque, status (queimadura, envenenamento,
  sono), dano por turno/contínuo.
- Sistema de tipos e resistências.
- Evolução por ponta/trade ou estado (e.g. uma escolha).
- Captura (pokéball/bola simples).
- Métrica de progresso: dex, selos, nível (opcional, não obrigatório).

## Fora do escopo (non-goals)
- Encontros aleatórios (battle cages, tela de batalha "GBC").
- Turnos, manhã/noite automático, ondas de inimigos.
- Level-grind pesado (cada nível não dobra o HP nem força).
- Multijogador online, MMORPG, ou rede.
- 3D heavy/3D modelagem — priorizar sprites/2.5D.

## Loop de jogo
1. Explorar a área 2.5D.
2. Entrar em contato com um monstro selvagem (sem chance oculta).
3. Batalhar em tempo real: contra-ataque, evadir, usar itens/ores.
4. Vencer ou fugir.
5. Capturar ou evoluir; evolução pode mudar a aparência/armas.
6. Fator: prox. área, novos Pokémon, ver o mapa crescer.

## Fases de entrega

| Fase | Entregável | Notas |
|------|------------|-------|
| 0 | Referencial do jogo (`AGENTS.md` já criado) | Escopo definido |
| 1 | Mini-loop: mover personagem pela área, 1 monstro inimigo em
tempo real, 1 tipo/1 status básico | MVP |
| 2 | 3-5 áreas, 6+ Pokémon, evoluções, captura | Playable |
| 3 | Gradiente de dificuldade, 2 tipos, mapa maior, selos | Inspirador |
| 4 | Estética final, balanceamento, doc | Produto |

## Arquitetura sugerida
- **2.5D side-view** — world plano 2D, personagem 3D leves com
  sombras/projeção.
- **Mundo** — mapa tile-based ou blox 2D com parallax.
- **Combate** — loop: state machine (idle/aim/chatting/critical).
- **Dados** — JSON ou CSV para tipos, evolução, status.
- **Engine** — recomenda-se Godot (2D nativo, 2.5D, gratuito e open
source). Alternativa: Phaser (web) ou Unity (mais complexo).
- **Scripts** — linguagem do engine escolhido; modularizar IA de
  monstro, sistema de status e captura.

## Métricas de sucesso
- MVP: em ~4 semanas, jogador lida com um batalha real-time de 1 vs 1
  com 1 tipo e 1 status.
- Alpha: 3 áreas, 6 Pokémon, captura e evolução funcionais.
- O jogo não fica "futuro" — pode jogar no 10º minuto.

## Perguntas abertas (decidir)
1. Tech stack? (Godot vs Phaser vs Unity)
2. 2.5D: side-view ou isometric?
3. Controle de combate: auto (agente decide) ou ação direta (o jogador
   corta/gatilhos)?
4. Sequência original ou distorcida (ex: somente Pokémon do Crystal)?
5. Intenção: aprendizado, fama, projeto completo?

## Próximos passos
1. Decidir tech stack e 2.5D direction.
2. Scaffold: pastas `src/`, `assets/`, `data/`, engine project.
3. Fase 1: mover personagem + um inimigo simples.
4. Commit e atualizar `README.md`/Obsidian.
