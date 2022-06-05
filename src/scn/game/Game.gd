# Game
extends Node

# On Quit2Title button pressed
func _on_title_btn_pressed():
  Events.emit_signal("show_title")

# On Quit2Desktop button pressed
func _on_quit_btn_pressed():
  Events.emit_signal("quit2desktop")
