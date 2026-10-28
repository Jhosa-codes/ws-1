class_name PokemonData
## Uma instância de Pokémon em batalha: stats, HP atual, tipo, moves.
## Os dados vêm de data/pokemon.json + data/moves.json.
##
## Como usar:
##   var p = PokemonData.new()
##   p.init_from_record(registro, moves_json)
##   p.take_damage(12)
##   p.is_alive()

var id: int
var name: String
var types: Array = []
var max_hp: int
var hp: int
var atk: int
var def: int
var spd: int
var sat: int
var sdf: int
var move_ids: Array = []

## Monta a instância a partir de um registro do pokemon.json.
## `moves_data` é o dict carregado de data/moves.json.
func init_from_record(record: Dictionary, moves_data: Dictionary) -> void:
	id = record["id"]
	name = record["name"]
	types = record.get("types", [])
	var s: Dictionary = record["stats"]
	max_hp = int(s["hp"])
	hp = max_hp
	atk = int(s["atk"])
	def = int(s["def"])
	spd = int(s["spd"])
	sat = int(s["sat"])
	sdf = int(s["sdf"])
	move_ids = record.get("moves", [])

func is_alive() -> bool:
	return hp > 0

func take_damage(raw: int) -> void:
	hp = maxi(0, hp - raw)

## Devolve os dados de um move pelo nome (vazio se não existir).
func get_move(name: String, moves_data: Dictionary) -> Dictionary:
	return moves_data.get(name, {})
