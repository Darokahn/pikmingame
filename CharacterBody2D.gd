extends Body

const SPEED = 150.0

var anim_state = "idle"
var facing_dir = Vector2()
var cursor = Vector2()
var follow_cursor = Vector2()
var throw_len = 100
var follow_dist = 20
var squad = []
var throw_tolerance = 30
var whistle_time = 0

var height = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func custom_get_axis():
	var axes = Vector2()
	if Input.is_action_pressed("left"):
		axes[0] -= 1
	if Input.is_action_pressed("right"):
		axes[0] += 1
	if Input.is_action_pressed("up"):
		axes[1] -= 1
	if Input.is_action_pressed("down"):
		axes[1] += 1
	return axes

func throw_piki():
	for piki in squad:
		var distance = (follow_cursor - piki.position).length()
		if distance <= throw_tolerance and not piki.flying and piki.leader == self:
			piki.position = position
			piki.fly(cursor)
			return
			
func whistle(object):
	object = object.get_parent()
	if object.has_method("is_piki"):
		object.unlatch()
		object.join_squad(self)
	
func _process(delta):
	follow_dist = (sqrt(len(squad)) * 2) + 10
	cursor = (get_viewport().get_mouse_position() - (get_viewport_rect().size/2)) / $Camera2D.zoom
	$Cursor/pointer.offset = cursor
	if cursor.length() > throw_len:
		cursor = cursor.normalized() * throw_len
	$Cursor/cursor.position = cursor
	if Input.is_action_just_pressed("summon_piki"):
		get_node("../..").add_piki(position, self)
	if Input.is_action_just_pressed("throw_piki"):
		throw_piki()
	
	if Input.is_action_just_pressed("whistle"):
		$AudioStreamPlayer2D.play()
	
	cursor = $Cursor/cursor/CollisionShape2D
	
	if Input.is_action_pressed("whistle"):
		whistle_time += 1
		var whistle_size = clamp(0, whistle_time/2, 20)
		
		cursor.scale = Vector2(whistle_size, whistle_size)
		cursor.set_deferred("disabled", false)
		
	if Input.is_action_just_released("whistle"):
		whistle_time = 0
		$AudioStreamPlayer2D.stop()
		cursor.scale = Vector2(0.1, 0.1)
		cursor.set_deferred("disabled", true)
		
func _ready():
	cursor = position
	follow_cursor = position
	facing_dir = Vector2(1, 0)
	z_index = 1
	$Cursor/cursor.connect("area_entered", whistle)


func _physics_process(delta):
	var prev_state = anim_state
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var axes = custom_get_axis()
	var xDirection = axes[0]
	var yDirection = axes[1]
	
	if xDirection and yDirection:
		xDirection /= sqrt(2)
		yDirection /= sqrt(2)
	if xDirection: 
		velocity.x = xDirection * SPEED
	else:
		velocity.x = 0
	if yDirection:
		velocity.y = yDirection * SPEED
	else:
		velocity.y = 0
		
	if xDirection or yDirection:
		facing_dir = Vector2(xDirection, yDirection)
	follow_cursor = (facing_dir * -follow_dist) + position
		
	if not (xDirection or yDirection):
		sprite.stop()
		sprite.frame = 1
	else:
		sprite.play()
	if yDirection > 0:
		anim_state = "walk_down"
	elif yDirection < 0:
		anim_state = "walk_up"
	elif xDirection < 0:
		anim_state = "walk_side"
		sprite.flip_h = true
	elif xDirection > 0:
		anim_state = "walk_side"
		sprite.flip_h = false
	if not anim_state == sprite.animation:
		sprite.play(anim_state)

	move_and_slide()
