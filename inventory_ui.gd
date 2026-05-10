extends CanvasLayer

@onready var grid: GridContainer = $Panel/GridContainer
@onready var panel: Panel = $Panel

# Grab our new menu nodes
@onready var context_menu: Panel = $ContextMenu
@onready var use_btn: Button = $ContextMenu/VBoxContainer/UseButton
@onready var drop_btn: Button = $ContextMenu/VBoxContainer/DropButton

var selected_slot: int = -1

func _ready() -> void:
	panel.hide()
	context_menu.hide() # Hide menu on start
	
	GlobalInventory.inventory_updated.connect(update_ui)
	
	for i in range(GlobalInventory.MAX_SLOTS):
		var slot = grid.get_child(i)
		slot.slot_index = i
		
	update_ui()
	
	# Connect our Context Menu buttons via code!
	use_btn.pressed.connect(_on_use_button_pressed)
	drop_btn.pressed.connect(_on_drop_button_pressed)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_inventory"):
		panel.visible = !panel.visible
		context_menu.hide() # Always close menu when closing inventory

func update_ui() -> void:
	for i in range(GlobalInventory.MAX_SLOTS):
		var slot = grid.get_child(i)
		var icon_rect = slot.get_node("ItemIcon")
		var item = GlobalInventory.items[i]
		
		if item != null:
			icon_rect.texture = load(item["icon"])
		else:
			icon_rect.texture = null

# --- NEW: CONTEXT MENU FUNCTIONS ---

func open_context_menu(slot_index: int, mouse_pos: Vector2) -> void:
	selected_slot = slot_index
	var item = GlobalInventory.items[slot_index]
	
	if item["type"] == "weapon":
		if GlobalInventory.equipped_weapon == item["name"]:
			use_btn.text = "Unequip"
		else:
			use_btn.text = "Equip"
			
	# --- NEW: Change text for armor ---
	elif item["type"] == "armor":
		if GlobalInventory.equipped_armor == item["name"]:
			use_btn.text = "Unequip"
		else:
			use_btn.text = "Equip"
			
	else:
		use_btn.text = "Use"
		
	context_menu.global_position = mouse_pos
	context_menu.show()

func _on_use_button_pressed() -> void:
	GlobalInventory.use_item(selected_slot)
	context_menu.hide()

func _on_drop_button_pressed() -> void:
	# Use the drop function we wrote earlier!
	var dropped_item = GlobalInventory.drop_item(selected_slot)
	if dropped_item != null:
		panel.spawn_item_in_world(dropped_item) # Calls the spawn function on the Panel
	context_menu.hide()
