extends Node2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.get("jump_pad_max"):
			body.velocity.y = body.jump_pad_max
			
			body.JUMP_COUNT = 2
			$Sprite2D/AnimationPlayer.play("active")
			 # Replace with function body.
