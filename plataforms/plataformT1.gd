
extends Area2D

var bAlreadyIn=false

# if destroyed
var bActive = true



func _ready():
	add_to_group(get_node("/root/globals").GP_DESTRUCTABLES)
	add_to_group(get_node("/root/globals").GP_PLATAFORMS)
	pass




func _on_plataform_body_enter( body ):
	if (not bAlreadyIn):
		bAlreadyIn=true
		get_node("AnimationPlayer").play("explosion")
		



func restart():
	bAlreadyIn=false
	bActive = true
	get_node("plataformSprite").show()


func _on_AnimationPlayer_finished():
	bActive = false
	get_node("explosionAnimation").hide()



func explode():
	#print ("EXPLODE")
	get_node("plataformSprite").hide()
	get_node("explosionAnimation").show()
	if (Globals.get("SOUND")):
		get_node("sound").play("explosion")
	

func _on_p_type_1__body_exit( body ):
	if (bAlreadyIn):
		bActive = false


