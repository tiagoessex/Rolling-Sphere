extends Node



# groups
const GP_DESTRUCTABLES = "destructables"
const GP_PLATAFORMS = "plataforms"
const GP_EXIT = "exit"
const GP_PLAYER = "player"
const GP_TELEPORT = "teleport"
const GP_PLATAFORM_HORIZONTAL = "horizontal"
const GP_PLATAFORM_VERTICAL = "vertical"


#The currently active scene
var currentScene = null

# true when ready to pass to next level <= all plataforms destroyed
var bNextLevel = false

# bNextLevel and player on the exit plataform
var bPlayerOnExit = false

# actually is time in secs
#var score = 0

var configFilename = "user://rb_config.ini"
var myconf
#var cont_game_score = 0
#var cont_game_level = 0
#var hi_score = 0


func _ready():
	Globals.set("MAXLEVELS",33)
	Globals.set("GRIDSIZE",64)
	Globals.set("PLAYERSPEED",125)
	Globals.set("SOUND",true)
	Globals.set("MUSIC",true)
	Globals.set("START",false)
	Globals.set("LEVEL",1)	# current level
	Globals.set("SCORE",0)	# current score (time in secs)
	Globals.set("DIALOGACTIVATED",false)	# for pause/resume issues
	Globals.set("CONTSCORE",0)
	Globals.set("CONTLEVEL",1)
	Globals.set("HISCORE",0)
		
	myconf = ConfigFile.new()
	myconf.load(configFilename)
	if myconf.has_section("cont_game"):
		Globals.set("CONTSCORE",myconf.get_value("cont_game","cont_game_score"))
		Globals.set("CONTLEVEL",myconf.get_value("cont_game","cont_game_level"))
	if myconf.has_section("hiscore"):
		Globals.set("HISCORE",myconf.get_value("hiscore","hiscore"))

	#On load set the current scene to the last scene available
	currentScene = get_tree().get_root().get_child(get_tree().get_root().get_child_count() -1)


# create a function to switch between scenes 
func setScene(scene):
	#clean up the current scene
	currentScene.queue_free()
	#load the file passed in as the param "scene"
	var s = ResourceLoader.load(scene)
	#create an instance of our scene
	currentScene = s.instance()
	# add scene to root
	get_tree().get_root().add_child(currentScene)
	
	bNextLevel = false
	bPlayerOnExit = false


# during level nothing is eliminated, only hidden
# hence call restart of all funcs
func restartLevel():
	var remaing_plataforms = get_tree().get_nodes_in_group(GP_PLATAFORMS)	
	for p in remaing_plataforms:
		p.restart()

	var remaing_plataforms = get_tree().get_nodes_in_group(GP_PLAYER)
	bNextLevel = false
	for p in remaing_plataforms:
		p.restart()

	bNextLevel = false
	bPlayerOnExit = false
	Globals.set("START",false)
	Globals.set("DIALOGACTIVATED",false)
	
	currentScene.restart()



# if true then ready to exit
func isLevelComplete():
	if (bNextLevel):
		return true;
	var remaing_plataforms = get_tree().get_nodes_in_group(GP_DESTRUCTABLES)
	for p in remaing_plataforms:
		#if p.bActive:
		if not p.bAlreadyIn:
			return false
	bNextLevel = true
	activateExit()
	return true


func activateExit():
	#print ("EXIT ACTIVATED")
	var exit = get_tree().get_nodes_in_group(GP_EXIT)	# maybe there are more than 1?
	for p in exit:
		p.showExit()



# to center the plataforms and player in middle of viewport
# regardless of the device width
func centerStuff():
	var original = 832
	var to_move = currentScene.get_node("gameobjects")
	#print (to_move.get_pos())
	if (to_move):
		var root = get_node("/root")
		var resolution = root.get_rect()
		var delta = (resolution.size.x - original) / 2
		to_move.set_pos(Vector2(to_move.get_pos().x + delta, to_move.get_pos().y))
		#print (resolution)#832
		#print (resolution.size.x )#832

func loadLevel(level):
	var next_level_name = "level" + str(Globals.get("LEVEL"))
	setScene("res://game/scenes/" + next_level_name + ".scn")

func saveCurrentShits():
	myconf.set_value("cont_game","cont_game_score",Globals.get("SCORE"))
	myconf.set_value("cont_game","cont_game_level",Globals.get("LEVEL"))
	Globals.set("CONTSCORE",Globals.get("SCORE"))
	Globals.set("CONTLEVEL",Globals.get("LEVEL"))
	myconf.save(configFilename)


func loadNextLevel():
	#print ("loading next level")
	bPlayerOnExit = true
	var next_level_number = Globals.get("LEVEL") + 1
	if next_level_number <= Globals.get("MAXLEVELS"):
		Globals.set("LEVEL",next_level_number)
		#var next_level_name = "level" + str(Globals.get("LEVEL"))		
		#setScene("res://game/scenes/level2.scn")
		loadLevel(next_level_number)
		# save stuff
		saveCurrentShits()
	else:
		#print ("---- VICTORY -----")
		if (Globals.get("HISCORE") == 0):
			myconf.set_value("hiscore","hiscore",Globals.get("SCORE"))
			Globals.set("HISCORE",Globals.get("SCORE"))
		else:
			if (Globals.get("SCORE") < Globals.get("HISCORE")):
				myconf.set_value("hiscore","hiscore",Globals.get("SCORE"))
				Globals.set("HISCORE",Globals.get("SCORE"))
		myconf.save(configFilename)
		
		currentScene.get_node("level_ui/dlg_victory").show()



func getCurrentScoreInGoodFormat(score):
	var hours = score / 3600;
	var minutes = (score % 3600) / 60;
	var seconds = score % 60;
	return str(hours) + "h:" + str(minutes).pad_zeros(2) + "m:" + str(seconds).pad_zeros(2) + "s"


func pause():
	var remaing_plataforms = get_tree().get_nodes_in_group(GP_PLATAFORMS)	
	for p in remaing_plataforms:
		p.hide()

	var remaing_plataforms = get_tree().get_nodes_in_group(GP_PLAYER)
	for p in remaing_plataforms:
		p.hide()
	
	var pause_label = currentScene.get_node("level_ui/pause")
	if (pause_label):
		pause_label.show()
	
	if (Globals.get("MUSIC")):
		var music = currentScene.get_node("music")
		if music:
			music.set_paused(true)
	
	#if (currentScene.get_node("level_ui/upper_menu/pause").is_pressed()):
	currentScene.get_node("level_ui/upper_menu/pause").set_pressed(true)

	get_tree().set_pause(true)



func resume():
	var remaing_plataforms = get_tree().get_nodes_in_group(GP_PLATAFORMS)	
	for p in remaing_plataforms:
		p.show()

	var remaing_plataforms = get_tree().get_nodes_in_group(GP_PLAYER)
	for p in remaing_plataforms:
		p.show()
	
	var pause_label = currentScene.get_node("level_ui/pause")
	if (pause_label):
		pause_label.hide()
	
	if (Globals.get("MUSIC")):
		var music = currentScene.get_node("music")
		if music:
			music.set_paused(false)

	var pausebutton = currentScene.get_node("level_ui/upper_menu/pause")
	if pausebutton:
		pausebutton.set_pressed(false)
	
	get_tree().set_pause(false)
