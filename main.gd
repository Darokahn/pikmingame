extends Node2D

const piki = preload("res://piki.tscn")

var pikis = []

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
func sort_z_vals(a, b):
	if a.has_node("body") and b.has_node("body"):
		var a_body = a.get_node("body")
		var b_body = b.get_node("body")
		var a_sprite_size = a_body.sprite.sprite_frames.get_frame_texture(a_body.sprite.animation, a_body.sprite.frame).get_size[1]
		var b_sprite_size = b_body.sprite.sprite_frames.get_frame_texture(b_body.sprite.animation, b_body.sprite.frame).get_size[1]
		return (a_body.position.y + a_body.sprite.position.y + a_body.height + 1 + ((1/2) * a_sprite_size)) < (b_body.position.y + b_body.sprite.position.y + b_body.height + 1 + ((1/2) * b_sprite_size))
	elif a.has_method("is_terrain"):
		return true
		
func free_object(object):
	if object.has_meta("is_piki"):
		pikis.remove(object)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for i in range(get_child_count()):
		var child = get_child(i)
		if child.has_node("body"):
			var body = child.get_node("body")
			var sprite_size = body.sprite.sprite_frames.get_frame_texture(body.sprite.animation, body.sprite.frame).get_size()[1]
			child.z_index = body.position.y + body.sprite.position.y + body.height + 1 + ((1/2)*sprite_size*body.sprite.scale.y)
		elif not child.has_method("is_terrain"):
			child.z_index = child.get_node("sprite").position.x
		else:
			child.z_index = -4096
			
		var children = get_children()
		children.sort_custom(func(x ,y): return x.z_index < y.z_index)
		for z in range(children.size()):
			move_child(children[z], z)


func add_piki(pos, leader = null):
	var p = piki.instantiate()
	var p_main = p.get_node("body")
	p_main.position = pos
	p_main.leader = leader
	p_main.peers = pikis
	add_child(p)
	pikis.append(p_main)
	if leader:
		leader.squad.append(p_main)

