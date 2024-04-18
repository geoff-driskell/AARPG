class_name Player extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
var direction: Vector2          = Vector2.ZERO
var move_speed: float           = 100.0
var state: String               = "idle"
var cardinal_direction: Vector2 = Vector2.DOWN

func _process(delta: float) -> void:
	direction.x = Input.get_axis("left", "right")
	direction.y = Input.get_axis("up", "down")
	
	velocity = direction * move_speed
	if update_state() || update_direction():
		update_animation()
	
func _physics_process(delta: float) -> void:
	move_and_slide()

func update_direction() -> bool:
	var new_dir:  Vector2 = cardinal_direction
	if direction == Vector2.ZERO:
		return false
	if direction.y == 0:
		new_dir = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
	if direction.x == 0:
		new_dir = Vector2.UP if direction.y < 0 else Vector2.DOWN
	if new_dir == cardinal_direction:
		return false
	cardinal_direction = new_dir
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	return true

func update_state() -> bool:
	var new_state: String = "idle" if direction == Vector2.ZERO else "walk"
	if new_state == state:
		return false
	else:
		state = new_state
	return true
	
	
func anim_direction() -> String:
	if direction == Vector2.DOWN:
		return "down"
	elif direction == Vector2.UP:
		return "up"
	else:
		return "side"
	
func update_animation() -> void:
	animation_player.play(state + "_" + anim_direction())
	