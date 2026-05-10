extends Node2D

# --- NEW: Expose the dialogue list to the Inspector! ---
# @export_multiline makes the text box bigger in the editor so it's easier to type.
@export_multiline var note_pages: Array[String] = [
	"This is a blank note."
]

@onready var prompt: Label = $Label
var can_interact: bool = false

func _ready() -> void:
	prompt.hide()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		prompt.show()
		can_interact = true

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		prompt.hide()
		can_interact = false

func _input(event: InputEvent) -> void:
	if can_interact and event.is_action_pressed("interact"):
		get_viewport().set_input_as_handled() 
		read_note()

func read_note() -> void:
	# --- THE FIX: Pass the custom list from the Inspector into your DialogManager ---
	DialogManager.show_dialogue(note_pages)
