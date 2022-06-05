extends Node

### Signals ###

# Transition to "Title" Screens requested.
signal show_title

# Transition to "Play" Mode requested.
signal play_game

# Quit to Desktop requested.
signal quit2desktop


### "Public" utility functions ###

# connect that prints an error if something went wrong
func connect2(sName: StringName, callback: Callable) -> void:
  var err = connect(sName, callback)
  if err: print_connect_err(sName, callback.get_method(), err)

# prints signal connection errors
func print_connect_err(sname: String, fname: String, err: int) -> void:
  printerr (
    "Error connecting Events.%s to '%s'. %s"
     % [sname, fname, error_string(err)]
  )
