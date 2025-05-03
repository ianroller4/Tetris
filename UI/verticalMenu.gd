class_name VerticalMenu extends VBoxContainer

""" Selection Pointer """
@export var pointer : Node

signal chose(item : Control)

"""
Purpose:
	Called when entering scene
"""
func _ready():
	get_viewport().gui_focus_changed.connect(on_focus_changed)
	configure_focus()

"""
Purpose:
	Handles the input for the UI
Parameters:
	event - An input event
"""
func _unhandled_input(event):
	if not visible:
		return
	
	get_viewport().set_input_as_handled()
	
	var focusItem = get_focused()
	
	if is_instance_valid(focusItem) and event.is_action_pressed("ui_accept"):
		chose.emit(focusItem)

"""
Purpose:
	Gets the items to add to the menu. Adds the children of this node if they are 
	of type control
Return:
	items - The array of control node children
"""
func get_items() -> Array[Control]:
	var items : Array[Control] = []
	
	for child in get_children():
		if !(child is Control):
			continue
		items.append(child)
	
	return items

"""
Purpose:
	Sets up the menu's next items. IE if at the first item the second item will be 
	selected if down is pressed.
"""
func configure_focus():
	var items = get_items()
	
	var itemsCount = items.size()
	
	for i in itemsCount:
		
		var item : Control = items[i]
		
		# Allows for focus to change based on keyboard or mouse input
		item.focus_mode = Control.FOCUS_ALL 
		
		if i == 0:
			item.focus_neighbor_top = items[itemsCount - 1].get_path()
			item.focus_neighbor_left = items[itemsCount - 1].get_path()
			item.focus_previous = items[itemsCount - 1].get_path()
			item.grab_focus()
		else:
			item.focus_neighbor_top = items[i - 1].get_path()
			item.focus_neighbor_left = items[i - 1].get_path()
			item.focus_previous = items[i - 1].get_path()
		
		if i == itemsCount - 1:
			item.focus_neighbor_bottom = items[0].get_path()
			item.focus_neighbor_right = items[0].get_path()
			item.focus_next = items[0].get_path()
		else:
			item.focus_neighbor_bottom = items[i + 1].get_path()
			item.focus_neighbor_right = items[i + 1].get_path()
			item.focus_next = items[i + 1].get_path()

"""
Purpose:
	Return the menu item that is currently active
Return:
	focusItem - The currently focused item or null if the item is not a child of this node.
"""
func get_focused() -> Control:
	var focusItem = get_viewport().gui_get_focus_owner()
	
	return focusItem if focusItem in get_children() else null

"""
Purpose: 
	Move pointer to currently focused menu item so users can know what they
	are selecting.
"""
func update_selection():
	var focusItem = get_focused()
	
	if is_instance_valid(focusItem) and is_instance_valid(pointer) and visible:
		var X = pointer.global_position.x
		var Y = focusItem.global_position.y + 12
		pointer.global_position = Vector2(X, Y)

"""
Purpose:
	When focus changes this check if the new focus item is valid and if so calls
	update selection and plays a sound if not first time entering the scene
Parameters:
	item - Type control, item that is now in focus
"""
func on_focus_changed(item : Control):
	if not item or !(item in get_children()):
		return
	update_selection()
