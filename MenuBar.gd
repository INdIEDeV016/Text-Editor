extends HBoxContainer


onready var tween = $Tween

var buttons = ["File","Edit","View","Format","Help"]

func _ready():
	for button in buttons:
		var err = get_node(button).connect("toggled", self, "make_tween", [get_node(button).get_popup()])
		if err != OK:
			print("Couldn't press %s Button" % buttons)
	
	$File.get_popup().set_item_shortcut(0, set_shortcut(KEY_N, false), true)
	$File.get_popup().set_item_shortcut(1, set_shortcut(KEY_O, false), true)
	$File.get_popup().set_item_shortcut(2, set_shortcut(KEY_S, false), true)
	$File.get_popup().set_item_shortcut(5, set_shortcut(KEY_Q, false), true)
	
	$Edit.get_popup().set_item_shortcut(0, set_shortcut(KEY_Z, false), true)
	$Edit.get_popup().set_item_shortcut(1, set_shortcut(KEY_Z, true), true)
	$Edit.get_popup().set_item_shortcut(3, set_shortcut(KEY_X, false), true)
	$Edit.get_popup().set_item_shortcut(4, set_shortcut(KEY_C, false), true)
	$Edit.get_popup().set_item_shortcut(5, set_shortcut(KEY_V, false), true)
	$Edit.get_popup().set_item_shortcut(7, set_shortcut(KEY_T, false), true)

func make_tween(button_pressed, popup):
	if button_pressed:
		tween.interpolate_property(
			popup, "rect_scale",
			Vector2.RIGHT, Vector2.ONE,
			0.2,
			Tween.TRANS_QUINT, Tween.EASE_IN
		)
	else:
		popup.show()
		tween.interpolate_property(
			popup, "rect_scale",
			Vector2.ONE, Vector2.RIGHT,
			0.2,
			Tween.TRANS_QUINT, Tween.EASE_IN
		)
	tween.start()

func set_shortcut(key, shift: bool):
	var shortcut = ShortCut.new()
	var input_event_key = InputEventKey.new()
	input_event_key.set_scancode(key)
	if shift:
		input_event_key.shift = true
	input_event_key.control = true
	shortcut.set_shortcut(input_event_key)
	return shortcut
