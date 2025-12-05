extends Node2D

@export var destino: String
@export var origem: String
@export var distancia: int

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var portais = get_tree().get_nodes_in_group("portais")
	
		
		for portal in portais:
			if portal.get("origem"):
				if portal.origem == destino:
					var x = portal.position.x + portal.distancia
					
					var y = portal.position.y 
					if Input.is_action_just_pressed("entrar"):
						body.position = Vector2 (x,y)
		
