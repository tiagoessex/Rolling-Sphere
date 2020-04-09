
extends KinematicBody2D

#max tolerance to check coordinates
var TOLERANCE = Globals.get("GRIDSIZE") / 2#32#10

const LEFT = Vector2(-1,0)
const RIGHT = Vector2(1,0)
const UP = Vector2(0,-1)
const DOWN = Vector2(0,1)
const NONE = Vector2(0,0)



#const PLAYER_SPEED = 150
var player_speed

var grid_size

var direction = NONE
var bChangeDirAllowed = true
var soFar = 0
var delta_x = 0

var bUp = false
var bDown = false
var bLeft = false
var bRight = false

var start_pos
var bAlive = true
var bTeleporting = false
var teleportdestination

var rotation = 0

var correction = Vector2()

func resetMovs():
	bUp = false
	bDown = false
	bLeft = false
	bRight = false
	direction = NONE
	bChangeDirAllowed = true
	soFar = 0
	delta_x = 0
	bTeleporting = false

func restart():
	set_pos(start_pos)
	resetMovs()
	#direction = Vector2(0,0)
	#bChangeDirAllowed = true
	#soFar = 0
	#delta_x = 0
	#bUp = false
	#bDown = false
	#bLeft = false
	#bRight = false
	bAlive = true
	#bTeleporting = false
	get_node("Sprite").show()
	get_node("playerDeath").hide()
	#print (start_pos)


func setPos(pos):
	start_pos = pos
	set_pos(pos)

func _ready():
	grid_size = Globals.get("GRIDSIZE")
	add_to_group(get_node("/root/globals").GP_PLAYER)
	set_fixed_process(true)
	player_speed = Globals.get("PLAYERSPEED")



func _fixed_process(delta):
	if (not bAlive || get_node("/root/globals").bPlayerOnExit || not Globals.get("START")):
		return
	
	#if (bTeleporting):
	#	bTeleporting = false
	#	return
	
	var move_left = Input.is_action_pressed("move_left") && not isVertical()
	var move_right = Input.is_action_pressed("move_right") && not isVertical()
	var move_up = Input.is_action_pressed("move_up") && not isHorizontal()
	var move_down = Input.is_action_pressed("move_down") && not isHorizontal()
	var player_pos = get_pos()
	
	
	if (move_left):
		bLeft = true
		bRight = false
		bUp = false
		bDown = false

	if (move_right):
		bLeft = false
		bRight = true
		bUp = false
		bDown = false

	if (move_up):
		bLeft = false
		bRight = false
		bUp = true
		bDown = false

	if (move_down):
		bLeft = false
		bRight = false
		bUp = false
		bDown = true

	if (bChangeDirAllowed):
		if (bLeft):
			direction=LEFT
			bChangeDirAllowed = false
		elif (bRight):
			direction=RIGHT
			bChangeDirAllowed = false
		elif (bUp):
			direction=UP
			bChangeDirAllowed = false
		elif (bDown):
			direction=DOWN
			bChangeDirAllowed = false


	
	delta_x = direction * player_speed * delta
	soFar += delta_x.length()
	move(delta_x)	# the right way to move kinematic chars. otherwise static and rigidbodies would not affect its movs
	if (soFar >= grid_size):
	
		######################
		#correct possible deviation
		var deviation = soFar - grid_size
		if deviation > 0:
			move(-deviation * direction)
		else:
			move(deviation * direction)
		
		#var xx = int(get_pos().x / grid_size) + 1
		#var yy = int(get_pos().y / grid_size) + 1
		#correction.x = xx * grid_size - grid_size / 2
		#correction.y = yy * grid_size - grid_size / 2		
		#set_pos(correction)
		######################
	
		if (not bTeleporting):
			bChangeDirAllowed = true
			soFar = 0
			get_node("/root/globals").isLevelComplete()
			
			if (not isOkPosition()):
				die()
		else:	# just to make sure it teleports only when in center
			bTeleporting = false
			set_pos(teleportdestination)
			resetMovs()
			#print ("here")
	#else:
	#	player_pos += delta_x
	#	set_pos(player_pos)
	#move(delta_x)
	
	rotation += delta * 6
	get_node("Sprite").set_rot(rotation)
	if rotation > 6.28:
		rotation = 0



func die():
	get_node("Sprite").hide()
	get_node("playerDeath").show()
	get_node("PlayerAnimations").play("death")
	#if (Globals.get("SOUND")):
	#	get_node("sound").play("gameover")
	if (Globals.get("SOUND")):
		get_node("sound").play("playerexp")
	bAlive = false
	get_node("../../score_timer").stop()
	
	if (Globals.get("MUSIC")):
		get_node("../../music").stop()
	


# player death
func endDeathAnimation():
	get_node("playerDeath").hide()
	get_node("../../level_ui/dlg_again").show()


# if false then player in empty space
func isOkPosition():
	var remaing_plataforms = get_tree().get_nodes_in_group(get_node("/root/globals").GP_PLATAFORMS)
	for p in remaing_plataforms:
		if (p.bActive):
			if ((p.get_pos().y - TOLERANCE < get_pos().y) and (p.get_pos().y + TOLERANCE > get_pos().y)):
				if ((p.get_pos().x - TOLERANCE < get_pos().x) and (p.get_pos().x + TOLERANCE > get_pos().x)):
					return true
	return false

# if true then player is in a horizontal plataform
func isHorizontal():
	var remaing_plataforms = get_tree().get_nodes_in_group(get_node("/root/globals").GP_PLATAFORM_HORIZONTAL)
	for p in remaing_plataforms:
		if ((p.get_pos().y - TOLERANCE < get_pos().y) and (p.get_pos().y + TOLERANCE > get_pos().y)):
			if ((p.get_pos().x - TOLERANCE < get_pos().x) and (p.get_pos().x + TOLERANCE > get_pos().x)):
				return true
	return false

# if true then player is in a horizontal plataform
func isVertical():
	var remaing_plataforms = get_tree().get_nodes_in_group(get_node("/root/globals").GP_PLATAFORM_VERTICAL)
	for p in remaing_plataforms:
		if ((p.get_pos().y - TOLERANCE < get_pos().y) and (p.get_pos().y + TOLERANCE > get_pos().y)):
			if ((p.get_pos().x - TOLERANCE < get_pos().x) and (p.get_pos().x + TOLERANCE > get_pos().x)):
				return true
	return false


func levelCompleted(move_2_this_pos):
	set_pos(move_2_this_pos)
	get_node("PlayerAnimations").play("level_passage")
	Globals.set("START",false)
	get_node("../../score_timer").stop()
	if (Globals.get("MUSIC")):
		get_node("../../music").stop()
	if (Globals.get("SOUND")):
		get_node("sound").play("nextlevel")




func teleportTo(destination):
	teleportdestination = destination
	bTeleporting = true

func endLevelPassageAnimation():
	get_node("/root/globals").loadNextLevel()

