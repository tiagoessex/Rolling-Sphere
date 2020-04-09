
extends Area2D

var bAlreadyIn=false
var bActive = true

func _ready():
	add_to_group(get_node("/root/globals").GP_EXIT)
	add_to_group(get_node("/root/globals").GP_PLATAFORMS)	



func _on_plataform_body_enter( body ):	
	if (not bAlreadyIn && get_node("/root/globals").bNextLevel):
		bAlreadyIn=true
		if get_node("/root/globals").bNextLevel:			
			if (body extends KinematicBody2D):
				get_node("../../player").levelCompleted(get_pos())
				
#			get_node("/root/globals").bPlayerOnExit = true
			#get_node("/root/globals").loadNextLevel()



func restart():
	bAlreadyIn=false
	bActive = true
	get_node("AnimatedSprite").set_frame(0)


func showExit():
	get_node("AnimatedSprite").set_frame(1)
	if (Globals.get("SOUND")):
		get_node("sound").play("showexit")
