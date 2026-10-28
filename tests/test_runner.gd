extends SceneTree
## Teste headless da lógica central do PokéSphere.
##
## Como rodar:
##   godot --headless --path . --script res://tests/test_runner.gd
##
## Verifica efetividade de tipos (super efetivo / neutro / imune / fora da
## tabela), a fórmula de dano com roll fixo (determinístico) e o ciclo de HP.
## Sai com código 0 se tudo passar, 1 se falhar.
##
## Nota: instancia o TypeSystem localmente (não usa o autoload global) porque
## em modo --script os autoloads ainda não estão registrados no parse. A
## integração completa (Battle.resolve_attack) é coberta pela playtest da
## cena principal (Main.tscn).

const PokemonData = preload("res://scripts/pokemon.gd")

func _init() -> void:
	print("=== TESTES DO POKÉSPHERE ===")
	var ok := true

	# --- Sistema de tipos (instância própria, carrega types.json agora) ---
	var ts: Node = preload("res://scripts/type_system.gd").new()
	ts._ready()
	ok = _assert(ts.get_effectiveness("ELECTRIC", "WATER") == 2.0, "ELECTRIC vs WATER = 2.0 (super efetivo)") and ok
	ok = _assert(ts.get_effectiveness("ELECTRIC", "GROUND") == 0.0, "ELECTRIC vs GROUND = 0.0 (imune)") and ok
	ok = _assert(ts.get_effectiveness("WATER", "ELECTRIC") == 1.0, "WATER vs ELECTRIC = 1.0 (neutro)") and ok
	ok = _assert(ts.get_effectiveness("ELECTRIC", "NORMAL") == 1.0, "tipo fora da tabela = 1.0 (neutro)") and ok

	# --- Fórmula de dano (roll=1.0 = determinístico) ---
	# ThunderShock(40) x Pikachu atk55 / Squirtle def65 x tipo 2.0 = 40*55/66*2 = 66.67 -> 66
	ok = _assert(ts.calculate_damage(40, 55, 65, 2.0, 1.0) == 66, "dano ThunderShock = 66 (recebido %d)" % ts.calculate_damage(40, 55, 65, 2.0, 1.0)) and ok
	# Water Gun(40) x Squirtle atk48 / Pikachu def30 x tipo 1.0 = 40*48/31 = 61.9 -> 61
	ok = _assert(ts.calculate_damage(40, 48, 30, 1.0, 1.0) == 61, "dano Water Gun = 61 (recebido %d)" % ts.calculate_damage(40, 48, 30, 1.0, 1.0)) and ok
	# Imunidade: multiplicador de tipo 0.0 -> dano 0.
	ok = _assert(ts.calculate_damage(40, 55, 65, 0.0, 1.0) == 0, "multiplicador 0.0 -> dano 0 (imune)") and ok

	# --- Dados carregam do JSON e ciclo de HP ---
	var pikachu: PokemonData = PokemonData.new()
	pikachu.init_from_record(_pikachu_record(), {})
	ok = _assert(pikachu.name == "Pikachu" and pikachu.max_hp == 35 and pikachu.atk == 55, "pokemon.json: Pikachu hp35 atk55") and ok
	ok = _assert(pikachu.is_alive(), "Pokémon começa vivo") and ok
	pikachu.take_damage(35)
	ok = _assert(not pikachu.is_alive() and pikachu.hp == 0, "HP zera e morre no dano exato") and ok

	print("\nRESULTADO: %s" % ("TODOS PASSARAM" if ok else "HOUVE FALHAS"))
	quit(0 if ok else 1)

func _assert(cond: bool, msg: String) -> bool:
	print("  [%s] %s" % ["PASS" if cond else "FAIL", msg])
	return cond

func _pikachu_record() -> Dictionary:
	return {
		"id": 25, "name": "Pikachu", "types": ["ELECTRIC"], "moves": ["THUNDERSHOCK"],
		"stats": {"hp": 35, "atk": 55, "def": 30, "spd": 90, "sat": 50, "sdf": 40},
	}
