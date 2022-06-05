# TransitionScreen
extends ColorRect
class_name TransitionScreen

### Constants ###

# Color used to transition to a blank image
const CLR_FADE_OUT := Color(0,0,0,1)

# Color used to transition from blank image
const CLR_FADE_IN  := Color(0,0,0,0)


### "Public" functions ###

# Fade-Out effect with Transition Screen.
func fade_out(callback: Callable) -> void:
  show()
  var tween := create_tween()
  tween.tween_property(self, "color", CLR_FADE_OUT, 0.2)
  tween.tween_callback(callback)

# Fade-In effect with Transition Screen.
func fade_in() -> void:
  var tween := create_tween()
  tween.tween_property(self, "color", CLR_FADE_IN, 0.2)
  tween.tween_callback(hide)
