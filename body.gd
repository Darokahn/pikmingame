extends Body

var height = 14
var health = 10

func on_death():
	var posy = get_node("../..")
	var pikis = owner.get_node("latchable").latched
	owner.remove_child(owner.get_node("latchable"))
	for piki in pikis:
		print("unlatching")
		piki.unlatch()
	var main = posy.get_parent()
	var new_pellet = load("res://pellet.tscn").instantiate()
	main.add_child(new_pellet)
	new_pellet.get_node("body").position = posy.get_node("sprite").position
	new_pellet.get_node("body").height = 0
	new_pellet.remove_child(new_pellet.get_node("latchable"))
	posy.queue_free()
	
