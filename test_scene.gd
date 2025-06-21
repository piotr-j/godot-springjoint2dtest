extends Node2D

@export var body_template: PackedScene


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("spawn"):
		var mp := get_global_mouse_position()
		
		var body: Node2D = body_template.instantiate()
		body.global_position = mp
		get_tree().root.add_child(body)
