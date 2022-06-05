# Main
extends Node

### Constants ###

# Resource Path to "Title" Scene
const TITLE_SCN_PATH := "res://src/scn/title/Title.tscn"

# Resource Path to "Game" Scene
const GAME_SCN_PATH := "res://src/scn/game/Game.tscn"


### OnReady ###

# Holds the current scene. (should it maintain the `current_scene` var?)
@onready var scene_node: Node = $SceneNode


### LifeCycle Callbacks ###

# on ready
func _ready() -> void:
  print_verbose("Main: ready!")
  connect_signals()
  scene_node.load_scene(TITLE_SCN_PATH)


### Signal Handlers ###

# Show the Game Scene
func _on_play_game() -> void:
  scene_node.load_scene(GAME_SCN_PATH)

# Show the Title Scene
func _on_show_title() -> void:
  scene_node.load_scene(TITLE_SCN_PATH)

# Exit the program
func _on_quit2desktop() -> void:
  get_tree().quit(0)


### "Private" helper functions ###

# Connects Main to Signals
func connect_signals() -> void:
  Events.connect2("play_game", _on_play_game)
  Events.connect2("show_title", _on_show_title)
  Events.connect2("quit2desktop", _on_quit2desktop)
