extends CharacterBody3D

@onready var target = $"../Player"

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED

	
func _process(delta: float) -> void:
	var direction = (target.global_position - global_position).normalized()
	velocity = direction * 5
	print(position)
	look_at(target.position)
	
	if !is_on_floor():
		velocity.y = 0 * delta
		
	if velocity != Vector3.ZERO:
		$Node3D/enemy_tonnel/AnimationPlayer.play("enemy_tonnel_walk")
	
	move_and_slide()


func _on_player_spawnmon() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	$"../AudioStreamPlayer3D".play()
	await $"../AudioStreamPlayer3D".finished
	$"../AudioStreamPlayer3D".stop()
