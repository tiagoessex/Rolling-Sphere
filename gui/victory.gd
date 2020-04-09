
extends TextureFrame

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	pass



func _on_dlg_victory_visibility_changed():
	if (is_visible()):
		Globals.set("DIALOGACTIVATED",true)
		get_node("/root/globals").pause()
		if (Globals.get("SOUND")):
			get_node("sound").play("victory")
	else:
		Globals.set("DIALOGACTIVATED",false)
		get_node("/root/globals").resume()



func _on_ok_pressed():
	if (Globals.get("SOUND")):
		get_node("sound").play("click")
	Globals.set("DIALOGACTIVATED",false)
	get_node("/root/globals").resume()
	get_node("/root/globals").setScene("res://game/scenes/mainmenu.scn")
