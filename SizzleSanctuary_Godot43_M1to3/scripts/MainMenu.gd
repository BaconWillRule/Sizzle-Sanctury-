
extends Control

@onready var start_btn: Button = $HBox/Left/Start
@onready var leaderboard_btn: Button = $HBox/Left/Leaderboard
@onready var controls_btn: Button = $HBox/Left/Controls
@onready var settings_btn: Button = $HBox/Left/Settings
@onready var quit_btn: Button = $HBox/Left/Quit

func _ready() -> void:
	start_btn.pressed.connect(_on_start_pressed)
	leaderboard_btn.pressed.connect(_on_leaderboard_pressed)
	controls_btn.pressed.connect(_on_controls_pressed)
	settings_btn.pressed.connect(_on_settings_pressed)
	quit_btn.pressed.connect(_on_quit_pressed)

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Game.tscn")

func _on_leaderboard_pressed() -> void:
	print("Leaderboard pressed (placeholder)")

func _on_controls_pressed() -> void:
	print("Controls pressed (placeholder)")

func _on_settings_pressed() -> void:
	print("Settings pressed (placeholder)")

func _on_quit_pressed() -> void:
	get_tree().quit()
