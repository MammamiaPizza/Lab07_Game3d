extends CharacterBody3D

signal death
signal escape
signal spawnmon

@export var speed : int = 4
@export var gravity : int = 75

var basespeed = speed
var maxspeed = 8

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var contractray = $Head/Camera3D/RayCast3D

var itemcount = 0
var maxitemcount = 5

var mousesentivity = 0.005

var item

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
			head.rotate_y((mousesentivity * -event.relative.x))
			camera.rotate_x((mousesentivity * -event.relative.y))
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(60))


func _physics_process(delta: float) -> void:
	
	var axisx = Input.get_axis("left", "right")
	var axisz = Input.get_axis("forward", "backward")
	
	var direction = Vector3.ZERO
	
	direction.x += axisx
	direction.z += axisz
	
	direction.normalized()
	
	direction = direction.rotated(Vector3.UP, camera.global_rotation.y)
	
	if Input.is_action_pressed("run"):
		speed = maxspeed
	else:
		speed = basespeed
	
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
		
	if !is_on_floor():
		velocity.y = velocity.y - (gravity * delta)
	
	if contractray.is_colliding():
		item = contractray.get_collider()
		if item.is_in_group("interact"):
			if Input.is_action_just_pressed("click"):
				item.free()
				$collect.play()
				itemcount += 1
				if itemcount == maxitemcount:
					$"../Control/CanvasLayer/Label2".show()
				elif itemcount == 1:
					spawnmon.emit()
		elif item.is_in_group("car"):
			if Input.is_action_just_pressed("click"):
				if itemcount == maxitemcount:
					escapetrue()
				else:
					cantescape()
					
	if velocity == Vector3.ZERO:
		$AudioStreamPlayer3D.play()

	move_and_slide()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Entity"):
		#print("hello")
		queue_free()
		death.emit()
		

func escapetrue():
	escape.emit()

func cantescape():
	$"../Control/CanvasLayer/Label4".show()
	await get_tree().create_timer(2).timeout
	$"../Control/CanvasLayer/Label4".hide()
