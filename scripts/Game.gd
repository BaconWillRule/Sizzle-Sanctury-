
extends Node2D

@onready var music: AudioStreamPlayer = AudioStreamPlayer.new()

func _ready() -> void:
    add_child(music) # assign stream later

func _process(_delta: float) -> void:
    if Input.is_key_pressed(KEY_ESCAPE):
        get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

    if Input.is_action_just_pressed("music_toggle"):
        music.stream_paused = not music.stream_paused
    if Input.is_action_just_pressed("music_vol_down"):
        music.volume_db = max(-40.0, music.volume_db - 2.0)
    if Input.is_action_just_pressed("music_vol_up"):
        music.volume_db = min(6.0, music.volume_db + 2.0)
