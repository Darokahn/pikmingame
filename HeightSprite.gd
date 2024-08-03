extends Node
class_name HeightSprite

var body
var sprite

func _ready():
	body = owner.get_node("body")
	sprite = body.get_node("sprite")
	
func _process(delta):
	sprite.position.y = -body.height	
