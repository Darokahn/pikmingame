extends AnimatedSprite2D
var pellet_color = Vector4(255, 0, 0, 0)
var pellet_type = "red"


func _ready():
	material.set_shader_parameter("color", pellet_color)
