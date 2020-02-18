extends Area2D

signal hit

export var speed = 400
var screen_size

func _ready():
	screen_size = get_viewport_rect().size
	hide()

func _process(delta):
	var velocity = Vector2()
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	var left_horizontal = Input.get_joy_axis(0, JOY_AXIS_0) # Horizontal
	var left_vertical = Input.get_joy_axis(0, JOY_AXIS_1)
	velocity.x += left_horizontal
	velocity.y += left_vertical
#	print("horizontal: ", left_horizontal, ", vertical: ", left_vertical)	
	
	if velocity.length() > 0.1:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	if abs(velocity.x) > abs(velocity.y):
		if velocity.length() > 0.1:
			$AnimatedSprite.animation = "right"
			$AnimatedSprite.flip_v = false
			$AnimatedSprite.flip_h = velocity.x < 0
	else:
		if velocity.length() > 0.1:
			$AnimatedSprite.animation = "up"
			$AnimatedSprite.flip_v = velocity.y > 0


func _on_Player_body_entered(body):
	hide()
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
