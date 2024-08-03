extends AnimatedSprite2D

var attack_animation_timer = 0.0

func get_rotation_mod(attack_animation_timer):
	var animation_point = attack_animation_timer
	
	if animation_point < PI:
		return sin(0.5 * animation_point)
	else:
		return sin((2 * animation_point) - (PI * 0.5))
	
func attack_animate():
	var speed = 5
	var r = get_rotation_mod(float(attack_animation_timer))
	rotation = r
	
	if attack_animation_timer > (5*PI/4):
		attack_animation_timer = 0
		rotation = 0
		return
	attack_animation_timer += 0.01*PI*speed
		
func attack():
	attack_animation_timer = 1

func stop_attack():
	attack_animation_timer = 0
	rotation = 0
	
func _process(delta):
	if attack_animation_timer > 0:
		attack_animate()
