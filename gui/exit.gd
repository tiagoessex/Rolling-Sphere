
extends TextureFrame

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	pass




func _on_no_pressed():	
	hide()
	if (Globals.get("SOUND")):
		get_node("sound").play("click")


func _on_yes_pressed():
	hide()
	if (Globals.get("SOUND")):
		get_node("sound").play("click")
	get_tree().quit()



func _on_dlg_exit_visibility_changed():
	if (is_visible()):
		Globals.set("DIALOGACTIVATED",true)
		#get_node("/root/globals").pause()
		if (Globals.get("SOUND")):
			get_node("sound").play("dialog")
	else:
		Globals.set("DIALOGACTIVATED",false)
		#get_node("/root/globals").resume()


