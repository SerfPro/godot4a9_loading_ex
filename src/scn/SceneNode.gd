# SceneNode
extends Node

### Configuration ###

# NodePath to a LoadScreen instance
@export_node_path(LoadScreen) var load_screen_np: NodePath

# NodePath to a TransitionScreen instance
@export_node_path(TransitionScreen) var trans_screen_np: NodePath


### OnReady vars ###

# Loads files and displays a progress bar
@onready var load_screen: LoadScreen = get_node(load_screen_np)

# Controls fading in and out.
@onready var trans_screen: TransitionScreen = get_node(trans_screen_np)


### SceneNode State ###

# A Node representing the currently loaded scene
var current_scene: Node = null


### "Public" Functions ###

# Begins the loading process for switching to a new scene.
func load_scene(path: String) -> void:
  if ResourceLoader.has_cached(path):
    trans_screen.fade_out(_switch_to_cached.bind(path))
    return

  load_screen.load_scene(path)
  load_screen.show()

  if current_scene != null:
    _rem_current_scene()


### Signal Handlers ###

# Sets `loaded_path`; turns processing on
func _on_scene_loaded(path: String) -> void:
  trans_screen.fade_out(_show_loaded_scene.bind(path))


### "Private" helper functions ###

# Instances the cached scene and adds it as a direct child of Main.
func _switch_to_cached(path: String) -> void:
  var new_scene: Node = load(path).instantiate()
  add_child(new_scene)
  _rem_current_scene(new_scene)
  trans_screen.fade_in()

# Removes the current scene.
func _rem_current_scene(new_scene: Node = null) -> void:
  assert(current_scene != null)
  remove_child(current_scene)
  current_scene.queue_free()
  current_scene = new_scene

# Instances and adds the recently loaded scene.
func _show_loaded_scene(path: String) -> void:
  assert(current_scene == null)
  var new_scene: Node = ResourceLoader.load_threaded_get(path).instantiate()
  current_scene = new_scene
  add_child(current_scene)
  load_screen.hide()
  trans_screen.fade_in()
