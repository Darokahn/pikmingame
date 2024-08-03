extends Node
class_name latchable

var health
var latched = []
var latched_pos = []
var test = 1

var body


func latch(object):
	object = object.owner.get_node("body")
	if not object:
		return
	if object.has_method("is_piki") and object.tasked:
		print(get_parent())
		var height_difference = object.height - get_parent().get_node("body").height
		if abs(height_difference) > 10:
			pass
		object.latch(body)
		var relative = owner.get_node("body").position - object.position
		latched.append(object)
		latched_pos.append(relative)

func unlatch(object):
	var index = latched.find(object)
	latched.pop_at(index)
	latched_pos.pop_at(index)

func _ready():
	body = owner.get_node("body")
	owner.get_node("body/latchzone").connect("area_entered", latch)

func _process(delta):
	for piki in latched:
		piki.position = body.position + latched_pos[latched.find(piki)]
