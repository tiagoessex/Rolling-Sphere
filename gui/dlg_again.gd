
extends TextureFrame

# requirements:
#	- player
#	- globals

func _ready():
	# Initialization here
	pass





func _on_dlg_again_visibility_changed():
	if (is_visible()):
		Globals.set("DIALOGACTIVATED",true)
		get_node("/root/globals").pause()
		if (Globals.get("SOUND")):
			get_node("sound").play("dialog")
	else:
		Globals.set("DIALOGACTIVATED",false)
		get_node("/root/globals").resume()

func _on_yes_pressed():
	if Globals.get("SOUND"):
		get_node("sound").play("click")
	hide()
	get_node("/root/globals").restartLevel()
	
	


func _on_no_pressed():
	if Globals.get("SOUND"):
		get_node("sound").play("click")
	hide()
	
	#get_node("/root/globals").saveCurrentShits()
	
	get_node("/root/globals").setScene("res://game/scenes/mainmenu.scn")

