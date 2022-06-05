# LoadScreen
extends ColorRect
class_name LoadScreen

### Signals ###

# Emitted after a scene has been loaded.
signal SceneLoaded


### Components ###

# Scene Loading ProgressBar
@onready var load_pb: ProgressBar = $LoadPB


### Configuration ###

# Configure the rate the ProgressBar increments by per frame.
@export var increment_value: float = 200.0


### Loading State vars ###

# Currently loading Resource Path; blank if none.
var loading_path := ""

# Frame count of loading the Resource from loading_path
var load_frames := 0


### Lifecycle Callbacks ###

# Polls ResourceLoader for currently loading Resources.
func _process(delta: float) -> void:
  if loading_path.is_empty():
    set_process(false)
    return

  load_frames += 1

  match ResourceLoader.load_threaded_get_status(loading_path):
    ResourceLoader.ThreadLoadStatus.THREAD_LOAD_IN_PROGRESS:
      _increment_progress_bar(delta)
    ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
      print("Took %d frames to load '%s'" % [load_frames, loading_path])
      emit_signal("SceneLoaded", loading_path)
      _loading_ended(100)
    ResourceLoader.ThreadLoadStatus.THREAD_LOAD_FAILED:
      printerr("ResourceLoader Failed to load: %s" % loading_path)
      _loading_ended(0)
    ResourceLoader.ThreadLoadStatus.THREAD_LOAD_INVALID_RESOURCE:
      printerr("Invalid Resource: %s" % loading_path)
      _loading_ended(0)


### "Public" Functions ###

# Begins a threaded load request for the scene at the given path.
func load_scene(path: String) -> void:
  if !loading_path.is_empty():
    printerr("Already loading! '%s'" % loading_path)
    return

  var err = ResourceLoader.load_threaded_request(path, "PackedScene")
  if err:
    printerr("Error '%s' loading path '%s'" % [error_string(err), path])
    return

  loading_path = path
  set_process(true)


### "Private" helper functions ###

# Called when loading has stopped; successfully or not.
func _loading_ended(final_value: float) -> void:
  load_pb.value = final_value
  loading_path = ""
  load_frames = 0

# Increments the progress bar. Loops if current value is >= 99.
func _increment_progress_bar(delta: float) -> void:
  if load_pb.value >= 99.0:
    load_pb.value = 1.0
  else:
    load_pb.value += increment_value * delta
