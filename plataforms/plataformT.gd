
extends Area2D

export(Vector2) var destination = null

const TOLERANCE = 10	# just to make sure

var bActive = true

func _ready():
	add_to_group(get_node("/root/globals").GP_TELEPORT)
	add_to_group(get_node("/root/globals").GP_PLATAFORMS)	



func _on_plataform_body_enter( body ):
	if destination == null:
	#if destination.x == 0 or destination.y == 0:
		return
	var player = get_node("../../player")
	# to prevent bouncing back (inf. loop) - no need for tolerance because values are exact??
	#if (not (player.get_pos().x == get_pos().x && player.get_pos().y == get_pos().y)):
	# if 
	if ((player.get_pos().y - TOLERANCE < get_pos().y) and (player.get_pos().y + TOLERANCE > get_pos().y)):
			if ((player.get_pos().x - TOLERANCE < get_pos().x) and (player.get_pos().x + TOLERANCE > get_pos().x)):
				return
			#else:
	player.teleportTo(destination)
	if (Globals.get("SOUND")):
		get_node("sound").play("teleport")




func restart():
	bActive = true

