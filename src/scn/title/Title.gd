extends Node

# on play btn pressed
func _on_play_btn_pressed():
  Events.emit_signal("play_game")

# on quit btn pressed
func _on_quit_btn_pressed():
  Events.emit_signal("quit2desktop")
