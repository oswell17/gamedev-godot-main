extends Area2D

# This creates a text box in the Inspector so you can easily type "Room 101", "Cafeteria", etc.
@export var sign_text: String = "Room 000"

# Grab the Label node
@onready var display_label: Label = $Label

func _ready() -> void:
	# Update the label to show whatever you typed in the Inspector
	display_label.text = sign_text
	
	# Hide it when the game starts
	display_label.hide()

# --- SIGNALS ---

func _on_body_entered(body: Node2D) -> void:
	# If the player steps inside the collision circle, show the text!
	if body.name == "Player":
		display_label.show()

func _on_body_exited(body: Node2D) -> void:
	# If the player steps out of the circle, hide it again!
	if body.name == "Player":
		display_label.hide()
