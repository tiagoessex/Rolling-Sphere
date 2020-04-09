
extends TextureFrame

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# Initialization here
	pass



func _on_ok_pressed():
	if (Globals.get("SOUND")):
		get_node("sound").play("click")
	get_node("/root/globals").setScene("res://game/scenes/mainmenu.scn")




func _on_ok1_pressed():
	if (Globals.get("SOUND")):
		get_node("sound").play("click")
	get_node("/root/globals").setScene("res://game/scenes/help1.scn")
