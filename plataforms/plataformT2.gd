
extends Area2D

var bAlreadyIn=false

# if destroyed
var bActive = true

# how many touches without start its destruction
var counter = 1


func _ready():
	add_to_group(get_node("/root/globals").GP_DESTRUCTABLES)
	add_to_group(get_node("/root/globals").GP_PLATAFORMS)
	get_node("plataformSprites").set_frame(counter)
	pass




func _on_plataform_body_enter( body ):
	counter -= 1	
	if (counter < 0):
		if (not bAlreadyIn):
			bAlreadyIn=true
			get_node("AnimationPlayer").play("explosion")
	else:
		get_node("plataformSprites").set_frame(counter)
		if (Globals.get("SOUND")):
			get_node("sound").play("change")



func restart():
	bAlreadyIn=false
	bActive = true
	counter = 1
	get_node("plataformSprites").set_frame(counter)
	get_node("plataformSprites").show()


func _on_AnimationPlayer_finished():
	bActive = false
	get_node("explosionAnimation").hide()



func explode():
	print ("EXPLODE 2")
	get_node("plataformSprites").hide()
	get_node("explosionAnimation").show()
	if (Globals.get("SOUND")):
		get_node("sound").play("explosion")
	

func _on_p_type_1__body_exit( body ):
#	counter -= 1
#	get_node("plataformSprites").set_frame(counter)
	if (bAlreadyIn):
		bActive = false


