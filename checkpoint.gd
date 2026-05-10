extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		Global.respawn_position = global_position
		Global.has_checkpoint = true
		
		Global.player_health = body.current_health
		
		GlobalInventory.save_to_checkpoint()
		
		# --- NEW: Automatically grab the file path of the current level! ---
		Global.current_scene_path = get_tree().current_scene.scene_file_path
		
		# Now write everything to the hard drive
		Global.save_game()
		
		print("Checkpoint Reached! Saved position: ", global_position)
		$CollisionShape2D.set_deferred("disabled", true)
