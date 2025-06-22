class_name Attractor extends Area2D

@export var max_force := 1000.0
@export var dst_start := 30.0
@export var dst_end := 100.0
@export var dst_exp := 2.0

var bodies: Dictionary[RigidBody2D, bool]
var connected: Dictionary[RigidBody2D, bool]

func _ready() -> void:
	#print('%s ready! owner %s' % [self, owner])
	pass

func _on_body_entered(body: Node2D) -> void:
	if body is not RigidBody2D or body == get_parent():
		return
	var attractor := owner as TestAttractor
	if not attractor:
		return
	bodies[body as RigidBody2D] = true
	connected[body as RigidBody2D] = true
		
	
func _on_body_exited(body: Node2D) -> void:
	if body is not RigidBody2D or body == get_parent():
		return
	var attractor := owner as TestAttractor
	if not attractor:
		return
	bodies.erase(body)


func _physics_process(delta: float) -> void:
	var gp := global_position
	
	var too_far: Array[RigidBody2D] = []
	for body: RigidBody2D in connected.keys():
		var dir: Vector2 = (gp - body.global_position)
		var dst := dir.length()
		
		var alpha := 1.0 - clampf((dst - dst_start)/(dst_end - dst_start), 0.0, 1.0)
		alpha = pow(alpha, dst_exp)
		var force := alpha * max_force * delta * body.mass
		
		# perhaps only above certain amount of connections?
		# 
		force /= connected.size()
		
		dir /= dst
		body.apply_central_force(dir * force)
		
		if dst >= dst_end:
			too_far.append(body)
		
		#print('%s -> %s, dst %.2f, alpha %.2f, force %.2f' % [owner, body.owner, dst, alpha, force])
	
	for body: RigidBody2D in too_far:
		connected.erase(body)

func _process(_delta: float) -> void:
	#if connected.size() > 0:
	queue_redraw()

func _draw() -> void:
	var gp := global_position
	for body: RigidBody2D in connected.keys():
		var dir: Vector2 = (gp - body.global_position)
		var dst := dir.length()
		dir /= dst
		
		var alpha := 1.0 - clampf((dst - dst_start)/(dst_end - dst_start), 0.0, 1.0)
		#print('%s -> %s alpha %.2f, exp %.2f dst %.2f'
		 #% [owner, body.owner, alpha, pow(alpha, dst_exp), dst])
		var color = Color.GREEN.lerp(Color.RED, 1.0 - alpha)
		
		var local_body_pos = to_local(body.global_position)
		draw_line(Vector2(0, 0), local_body_pos, color, 3.0)
		
	
		
	
