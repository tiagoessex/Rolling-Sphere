
extends HBoxContainer

# member variables here, example:
# var a=2
# var b="textvar"



func _ready():
	if (Globals.get("SOUND")):
		get_node("sound").set_pressed(false)
	else:
		get_node("sound").set_pressed(true)
	if (Globals.get("MUSIC")):
		get_node("music").set_pressed(false)
	else:
		get_node("music").set_pressed(true)
	pass




func _on_menu_pressed():
	if Globals.get("DIALOGACTIVATED"):
		get_node("menu").set_pressed(!get_node("menu").is_pressed())
		return
	# if it was in pause then it is no more
	# but since the dlg_sure pauses then it's ok
	#if (not get_node("pause").is_pressed()):
	#	get_node("pause").set_pressed(true)
	get_node("../dlg_sure").show()


func _on_pause_pressed():
	if Globals.get("DIALOGACTIVATED"):
		get_node("pause").set_pressed(!get_node("pause").is_pressed())
		return
	if (!get_tree().is_paused()):
		get_node("/root/globals").pause()
	else:
		get_node("/root/globals").resume()


func _on_sound_pressed():
	#get_node("/root/globals").bMute = !get_node("/root/globals").bMute
	Globals.set("SOUND",!Globals.get("SOUND"))
	


func _on_music_pressed():
	Globals.set("MUSIC",!Globals.get("MUSIC"))
	if (Globals.get("MUSIC")):
		get_node("../../music").set_paused(false)
	else:
		get_node("../../music").set_paused(true)
