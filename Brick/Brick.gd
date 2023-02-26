extends StaticBody2D

var score = 0
var new_position = Vector2.ZERO
var dying = false
var brick_sound = null
var sway_amplitude = 3.0
var sway_initial_position = Vector2.ZERO
var sway_randomizer = Vector2.ZERO

var powerup_prob = 0.1

func _ready():
	randomize()
	position = new_position
	if score == 100:
		$AnimatedSprite.frame = 0
	if score == 90:
		$AnimatedSprite.frame = 1
	if score == 80:
		$AnimatedSprite.frame = 2
	if score == 70:
		$AnimatedSprite.frame = 3
	if score == 60:
		$AnimatedSprite.frame = 4
	if score == 50:
		$AnimatedSprite.frame = 5
	if score <= 40:
		$AnimatedSprite.frame = 6
	sway_initial_position = $AnimatedSprite.position
	sway_randomizer = Vector2(randf()*6-3.0, randf()*6-3.0)
	
	
func _physics_process(_delta):
	var pos_x = (sin(Global.sway_index)*(sway_amplitude + sway_randomizer.x))
	var pos_y = (cos(Global.sway_index)*(sway_amplitude + sway_randomizer.y))
	$AnimatedSprite.position = Vector2(sway_initial_position.x + pos_x, sway_initial_position.y + pos_y)
	if dying and not $CPUParticles2D.emitting:
		queue_free()

func hit(_ball):
	die()

func die():
	brick_sound = get_node_or_null("/root/Game/Brick_Sound")
	if brick_sound != null:
		brick_sound.play()
	dying = true
	collision_layer = 0
	$AnimatedSprite.hide()
	Global.update_score(score)
	$CPUParticles2D.emitting = true
	#if not Global.feverish:
		#Global.update_fever(score)
	get_parent().check_level()
	if randf() < powerup_prob:
		var Powerup_Container = get_node_or_null("/root/Game/Powerup_Container")
		if Powerup_Container != null:
			var Powerup = load("res://Powerups/Powerup.tscn")
			var powerup = Powerup.instance()
			powerup.position = position
			Powerup_Container.call_deferred("add_child", powerup)
