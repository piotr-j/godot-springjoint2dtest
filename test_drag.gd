extends RigidBody2D

@export var local_root: Node2D

@export var joints : Array[DampedSpringJoint2D] = []

var is_dragging := false
var drag_offset := Vector2(0, 0)

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			is_dragging = event.pressed
			if event.pressed:
				drag_offset = global_position - get_global_mouse_position()
		elif event.button_index == MOUSE_BUTTON_MIDDLE:
			local_root.queue_free()
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		is_dragging = false
		
func _physics_process(delta: float) -> void:
	if not is_dragging:
		return

	var target_pos = get_global_mouse_position() + drag_offset
	var force = (target_pos - global_position) * 2000 * delta * mass
	apply_central_force(force)

func _process(_delta: float) -> void:
	if joints.size() > 0:
		queue_redraw()

func _draw() -> void:
	for joint: DampedSpringJoint2D in joints:
		var body_a = joint.get_node_or_null(joint.node_a)
		var body_b = joint.get_node_or_null(joint.node_b)

		if not body_a or not body_b:
			continue

		var local_pos_a = to_local(body_a.global_position)
		var local_pos_b = to_local(body_b.global_position)
		
		var dir := (local_pos_b - local_pos_a).normalized()
		draw_line(local_pos_a, local_pos_a + dir * joint.rest_length, Color.RED, 6.0)
		
	for joint: DampedSpringJoint2D in joints:
		var body_a = joint.get_node_or_null(joint.node_a)
		var body_b = joint.get_node_or_null(joint.node_b)

		if not body_a or not body_b:
			continue

		var local_pos_a = to_local(body_a.global_position)
		var local_pos_b = to_local(body_b.global_position)

		draw_line(local_pos_a, local_pos_b, Color.ORANGE, 3.0)
