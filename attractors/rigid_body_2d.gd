extends RigidBody2D

var is_dragging := false
var drag_offset := Vector2(0, 0)

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			is_dragging = event.pressed
			if event.pressed:
				drag_offset = global_position - get_global_mouse_position()
		elif event.button_index == MOUSE_BUTTON_MIDDLE:
			owner.queue_free()
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		is_dragging = false
		
func _physics_process(delta: float) -> void:
	if not is_dragging:
		return

	var target_pos = get_global_mouse_position() + drag_offset
	var force = (target_pos - global_position) * 2000 * delta * mass
	apply_central_force(force)
