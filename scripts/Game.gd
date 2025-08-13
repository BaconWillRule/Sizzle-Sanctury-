extends Node2D

@onready var music: AudioStreamPlayer = AudioStreamPlayer.new()
@onready var player: Node = null

func _ready() -> void:
    add_child(music) # assign stream later
    player = $Player
    _load_procgen_level()

func _process(_delta: float) -> void:
    if Input.is_key_pressed(KEY_ESCAPE):
        get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

    if Input.is_action_just_pressed("music_toggle"):
        music.stream_paused = not music.stream_paused
    if Input.is_action_just_pressed("music_vol_down"):
        music.volume_db = max(-40.0, music.volume_db - 2.0)
    if Input.is_action_just_pressed("music_vol_up"):
        music.volume_db = min(6.0, music.volume_db + 2.0)

func _load_procgen_level() -> void:
    # instantiate procedural level and hook spawns
    var path := "res://scenes/ProcGenLevel.tscn"
    if not ResourceLoader.exists(path):
        print("ProcGenLevel.tscn missing; skipping instantiation.")
        return
    var scene := load(path) as PackedScene
    var inst := scene.instantiate()
    add_child(inst)
    # wait a frame for it to place PlayerSpawn
    await get_tree().process_frame
    var spawn := inst.get_node_or_null("PlayerSpawn")
    if spawn and player:
        player.global_position = spawn.global_position
