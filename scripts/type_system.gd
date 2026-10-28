extends Node
## Autoload singleton "TypeSystem": sistema de tipos + fórmula de dano.
## Carrega data/types.json e expõe efetividade e cálculo de dano.
##
## Por que autoload: o sistema de tipos é usado por qualquer ator em batalha,
## então ele vive numa instância global acessível por `TypeSystem.xxx`.

var _effectiveness: Dictionary = {}

func _ready() -> void:
	_load_types()

func _load_types() -> void:
	var path := "res://data/types.json"
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		push_error("Não achou %s (erro %d)" % [path, FileAccess.get_open_error()])
		return
	var json := JSON.new()
	var parsed = json.parse_string(f.get_as_text())
	if parsed == null:
		push_error("types.json inválido")
		return
	_effectiveness = parsed

## Multiplicador de efetividade: tipo do ataque vs tipo do defensor.
## Tipos ausentes na tabela = 1.0 (neutro).
func get_effectiveness(atk_type: String, def_type: String) -> float:
	var row = _effectiveness.get(atk_type, {})
	return row.get(def_type, 1.0) if typeof(row) == TYPE_DICTIONARY else 1.0

## Fórmula de dano simplificada (ver docs/design/2026-10-27-pokesphere-design.md):
##   dano = power * (atk_atacante / (def_defensor + 1)) * fator_tipo * rand(0.85..1.0)
## Passar roll >= 0 deixa determinístico (útil pra testes).
func calculate_damage(power: float, atk: float, defense: float, type_mult: float, roll: float = -1.0) -> float:
	var r := roll if roll >= 0.0 else randf_range(0.85, 1.0)
	return floori(power * (atk / float(defense + 1)) * type_mult * r)
