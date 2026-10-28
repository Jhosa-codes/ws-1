extends Node
## Lógica pura de resolução de ataque — testável, sem dependência de cena.
## Usa TypeSystem pra efetividade e a fórmula de dano.

const PokemonData = preload("res://scripts/pokemon.gd")

## Resolve um ataque: `attacker` usa `move_name` contra `defender`.
## Devolve o dano aplicado (já com efetividade de tipo e roll).
## Multiplica a efetividade por TODOS os tipos do defensor (MVP: 1 tipo).
func resolve_attack(attacker: PokemonData, defender: PokemonData, move_name: String, moves_data: Dictionary, roll: float = -1.0) -> int:
	var move := attacker.get_move(move_name, moves_data)
	if move.is_empty():
		push_warning("Move desconhecido: %s" % move_name)
		return 0
	var power := float(move.get("power", 0))
	var atk_type := String(move.get("type", ""))
	var type_mult := 1.0
	if not atk_type.is_empty():
		for dt in defender.types:
			type_mult *= TypeSystem.get_effectiveness(atk_type, dt)
	return TypeSystem.calculate_damage(power, float(attacker.atk), float(defender.def), type_mult, roll)
