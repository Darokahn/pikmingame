extends Body


func is_piki():
	return true

var leader
var peers
var speed
const spacing_preference = 5
var friction = 0
var last_position
var dist_travelled = 0

var flying = false
var flight_dir = Vector2()
var gravity = 1
var height = 0
var z_velocity = 0
var flight_speed = 20

var latched = false
var latched_to = null

var tasked = false
var attack_speed = 4
var attack_pow = 1
var attack_timer = 0

func boid_move():
	for other in peers:
		if other == self:
			continue
		if position == other.position:
			position += Vector2(1, 1)
		var vector_to = (position - other.position)
		velocity += vector_to.normalized() * (spacing_preference/vector_to.length())
		
func fly(position):
	$fly.pitch_scale = 0.9 + (randf()/10)
	$fly.play()
	$tossed.play()
	flying = true
	velocity += position*4
	height += (randf()*3)
	z_velocity = 8
	leader = null
	tasked = true
	
func latch(object):
	latched = true
	latched_to = object
	$latch.play()
	
func unlatch():
	if latched:
		latched = false
		if owner.has_node("latchable"):
			latched_to.owner.get_node("latchable").unlatch(self)
		latched_to = null
		sprite.stop_attack()
		if latched_to:
			print(latched_to)
		
func attack():
	if attack_timer % (attack_speed*10) == 0:
		damage(latched_to, attack_pow)
		sprite.attack()
		attack_timer = 0
	attack_timer += 1
	
func damage(object, amount):
	object.get_node("Damageable").damage(amount)

func join_squad(l):
	if not leader:
		leader = l
		$called.play()

# Called when the node enters the scene tree for the first time.
func _ready():
	last_position = position
	speed = (randf()+1)

func move_normal():
	var leader_vector = position - leader.follow_cursor
	var mag = leader_vector.length()
	friction = 1/mag
	velocity -= leader_vector
	velocity = (velocity.normalized() * speed) / friction
	boid_move()
	move_and_slide()
	
	var jump_value
	dist_travelled += (position - last_position).length()/2
	dist_travelled = fmod(dist_travelled, 2*PI)
	jump_value = sin(dist_travelled)
	height = jump_value
	last_position = position

func move_flying():
	z_velocity -= gravity
	height += z_velocity
	sprite.rotation += 0.6
	move_and_slide()
	if height <= 0:
		sprite.rotation = 0
		velocity = Vector2()
		height = 0
		flying = false
		tasked = false

func _process(delta):
	if leader and not flying:
		if position[1] > leader.position[1]:
			z_index = leader.z_index + 1
		else:
			z_index = leader.z_index - 1
		move_normal()
	elif flying:
		move_flying()
	if latched:
		attack()
