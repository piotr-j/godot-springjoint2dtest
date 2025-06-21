extends DampedSpringJoint2D

@export var joint_color := Color.ORANGE

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
# Get the two nodes connected by the joint
	var body_a = get_node_or_null(node_a)
	var body_b = get_node_or_null(node_b)

	if not (body_a and body_b):
		return
	# Get the global positions of the connected nodes
	var pos_a = body_a.global_position
	var pos_b = body_b.global_position

	# Convert global positions to local coordinates for drawing
	var local_pos_a = to_local(pos_a)
	var local_pos_b = to_local(pos_b)

	# Draw a line between the two nodes
	draw_line(local_pos_a, local_pos_b, joint_color, 3.0)

	# Optionally draw anchor points
	#if draw_anchors:
		#draw_circle(local_pos_a, anchor_radius, debug_color)
		#draw_circle(local_pos_b, anchor_radius, debug_color)
