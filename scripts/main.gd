extends Node2D
## Ponto de entrada do PokéSphere (Main.tscn) — scaffold da Etapa 3.
##
## O que este scaffold faz:
##   1. Carrega os dados reais do Crystal (pokemon / types / moves).
##   2. Imprime um demo da lógica no Output (efetividade de tipo + dano).
##   3. Monta uma batalha 2D side-view mínima: Pikachu vs Squirtle, com
##      movimento (A/D), ataque automático em tempo real e barras de HP.
##
## O combate completo (esquiva com i-frames, IA do inimigo) vem na Etapa 4.

const POKEMON_JSON := "res://data/pokemon.json"
const MOVES_JSON := "res://data/moves.json"

const GROUND_Y := 300.0
const SPEED := 220.0
const PLAYER_ATTACK_SEC := 1.2
const ENEMY_ATTACK_SEC := 2.0
const HP_BAR_W := 180.0
const PokemonData = preload("res://scripts/pokemon.gd")

var _pokemon_data: Array = []
var _moves_data: Dictionary = {}
var _player: PokemonData
var _enemy: PokemonData

var _playerRect: ColorRect
var _enemyRect: ColorRect
var _playerHpFill: ColorRect
var _enemyHpFill: ColorRect
var _playerHpLabel: Label
var _enemyHpLabel: Label

var _player_x := 200.0
var _player_attack_cd := 0.0
var _enemy_attack_cd := ENEMY_ATTACK_SEC
var _battle_over := false

func _ready() -> void:
	randomize()
	_load_data()
	_print_logic_demo()
	_build_scene()
	_update_hp_ui()
	print("[Main] pronto. Feche a janela ou pressione F8 para parar.")

func _load_data() -> void:
	_pokemon_data = _read_json(POKEMON_JSON)
	_moves_data = _read_json(MOVES_JSON)
	_player = _make_pokemon(_pokemon_data[0])
	_enemy = _make_pokemon(_pokemon_data[1])

func _read_json(path: String) -> Variant:
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		push_error("Não achou %s (erro %d)" % [path, FileAccess.get_open_error()])
		return []
	var json := JSON.new()
	var parsed = json.parse_string(f.get_as_text())
	if parsed == null:
		push_error("%s inválido" % path)
		return []
	return parsed

func _make_pokemon(record: Dictionary) -> PokemonData:
	var p := PokemonData.new()
	p.init_from_record(record, _moves_data)
	return p

func _print_logic_demo() -> void:
	print("=== Demo da lógica (Output) ===")
	var eff := TypeSystem.get_effectiveness("ELECTRIC", "WATER")
	print("ThunderShock (ELECTRIC) vs Squirtle (WATER) = x", eff, " (super efetivo)")
	var dmg := Battle.resolve_attack(_player, _enemy, "THUNDERSHOCK", _moves_data, 1.0)
	print("Dano de 1 ThunderShock (roll=1.0): ", dmg)
	print("=================================")

func _build_scene() -> void:
	var bg := ColorRect.new()
	bg.color = Color(0.2, 0.3, 0.45)
	bg.size = get_viewport_rect().size
	add_child(bg)

	var ground := ColorRect.new()
	ground.color = Color(0.35, 0.28, 0.2)
	ground.position = Vector2(0, GROUND_Y)
	ground.size = Vector2(get_viewport_rect().size.x, 200)
	add_child(ground)

	_playerRect = _make_sprite(Color(0.95, 0.85, 0.2), _player.name, _player_x)
	_enemyRect = _make_sprite(Color(0.3, 0.55, 0.9), _enemy.name, 660.0)
	add_child(_playerRect)
	add_child(_enemyRect)

	_playerHpFill = _make_hp_bar(_player_x, 50.0)
	_enemyHpFill = _make_hp_bar(560.0, 50.0)
	add_child(_playerHpFill)
	add_child(_enemyHpFill)

	_playerHpLabel = Label.new()
	_playerHpLabel.position = Vector2(_player_x, 70)
	add_child(_playerHpLabel)
	_enemyHpLabel = Label.new()
	_enemyHpLabel.position = Vector2(560.0, 70)
	add_child(_enemyHpLabel)

func _make_sprite(color: Color, label: String, x: float) -> ColorRect:
	var r := ColorRect.new()
	r.color = color
	r.position = Vector2(x, GROUND_Y - 90)
	r.size = Vector2(90, 90)
	var t := Label.new()
	t.text = label
	t.position = Vector2(x - 8, GROUND_Y - 112)
	add_child(t)
	return r

func _make_hp_bar(x: float, y: float) -> ColorRect:
	var r := ColorRect.new()
	r.color = Color(0.2, 0.8, 0.3)
	r.position = Vector2(x, y)
	r.size = Vector2(HP_BAR_W, 14)
	return r

func _update_hp_ui() -> void:
	_playerHpFill.size.x = HP_BAR_W * float(_player.hp) / float(_player.max_hp)
	_enemyHpFill.size.x = HP_BAR_W * float(_enemy.hp) / float(_enemy.max_hp)
	_playerHpLabel.text = "%s  HP %d/%d" % [_player.name, _player.hp, _player.max_hp]
	_enemyHpLabel.text = "%s  HP %d/%d" % [_enemy.name, _enemy.hp, _enemy.max_hp]

func _process(delta: float) -> void:
	if _battle_over:
		return
	# Movimento do jogador (A/D ou setas).
	var dir := 0
	if Input.is_action_pressed("move_left"):
		dir -= 1
	if Input.is_action_pressed("move_right"):
		dir += 1
	_player_x = clampf(_player_x + dir * SPEED * delta, 40.0, 480.0)
	_playerRect.position.x = _player_x

	# Ataque automático do jogador (o Pokémon ataca sozinho — design híbrido).
	_player_attack_cd -= delta
	if _player_attack_cd <= 0.0:
		_player_attack_cd = PLAYER_ATTACK_SEC
		_player_attacks()
	if _battle_over:
		return
	# Ataque automático do inimigo.
	_enemy_attack_cd -= delta
	if _enemy_attack_cd <= 0.0:
		_enemy_attack_cd = ENEMY_ATTACK_SEC
		_enemy_attacks()

func _player_attacks() -> void:
	if not _enemy.is_alive():
		return
	var move = _player.move_ids[0]
	var dmg := Battle.resolve_attack(_player, _enemy, move, _moves_data)
	_enemy.take_damage(dmg)
	var mname = _player.get_move(move, _moves_data).get("name", move)
	print("%s usa %s -> %d de dano (HP %d/%d)" % [_player.name, mname, dmg, _enemy.hp, _enemy.max_hp])
	_update_hp_ui()
	if not _enemy.is_alive():
		_end_battle(true)

func _enemy_attacks() -> void:
	if not _player.is_alive():
		return
	var move = _enemy.move_ids[0]
	var dmg := Battle.resolve_attack(_enemy, _player, move, _moves_data)
	_player.take_damage(dmg)
	var mname = _enemy.get_move(move, _moves_data).get("name", move)
	print("%s usa %s -> %d de dano (HP %d/%d)" % [_enemy.name, mname, dmg, _player.hp, _player.max_hp])
	_update_hp_ui()
	if not _player.is_alive():
		_end_battle(false)

func _end_battle(player_won: bool) -> void:
	_battle_over = true
	print("\n=== %s ===" % ("VITÓRIA!" if player_won else "DERROTA..."))
