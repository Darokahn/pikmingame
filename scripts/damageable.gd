class_name Damageable extends Node

var body = null

func damage(amount):
	body.health -= amount
	
func _ready():
	body = get_parent()
	
func _process(delta):
	if body.health <= 0:
		body.on_death()

	
