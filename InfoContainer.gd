extends HBoxContainer


onready var zoom_slider = $"ZoomContainer/VSeparator2/ZoomPanel/HBoxContainer/HSlider"
onready var zoom_spin_box = $"ZoomContainer/VSeparator2/ZoomPanel/HBoxContainer/SpinBox"
onready var zoom_button = $ZoomContainer/ZoomButton
onready var zoom_panel = $"ZoomContainer/VSeparator2/ZoomPanel"
onready var tween = $"../Tween"

signal zoom_changed

var zoom = 100




func _ready():
	
# warning-ignore:return_value_discarded
	connect("zoom_changed", $"../TabContainer/Untitled/TextEdit", "calculate_zoom_percentage", [zoom_slider.max_value])
	
	tween.interpolate_property(
		self, "rect_position",
		Vector2(rect_position.x, OS.window_size.y + rect_size.y + 10), Vector2(rect_position.x, OS.window_size.y - rect_size.y),
		1,
		Tween.TRANS_QUINT, Tween.EASE_IN_OUT
	)
	tween.start()
	yield(tween, "tween_completed")
	OS.window_resizable = true

func _on_HSlider_value_changed(value):
	emit_signal("zoom_changed", value)
	zoom = value

func _on_SpinBox_value_changed(value):
	emit_signal("zoom_changed", value)
	zoom = value

func _on_ZoomButton_toggled(button_pressed):
	if button_pressed:
		show_panel()
	else:
		hide_panel()


func hide_panel():

	tween.interpolate_property(
			zoom_panel, "rect_position",
			zoom_panel.rect_position, Vector2(120, zoom_panel.rect_position.y),
			0.5,
			Tween.TRANS_QUINT, Tween.EASE_OUT
		)
	tween.start()
	yield(tween, "tween_completed")

func show_panel():
	zoom_panel.raise()
	tween.interpolate_property(
		zoom_panel, "rect_position",
		zoom_panel.rect_position, Vector2(-zoom_panel.rect_size.x, zoom_panel.rect_position.y),
		0.5,
		Tween.TRANS_QUINT, Tween.EASE_OUT
		)
	tween.start()
	yield(tween, "tween_completed")


func _process(_delta):
	zoom_slider.value = zoom
	zoom_spin_box.value = zoom
	zoom_button.text = "Zoom : %d%s" % [zoom, "%"]
	var control_key = InputEventKey.new()
	control_key.control = true
	if control_key.is_pressed() and Input.is_mouse_button_pressed(BUTTON_WHEEL_UP):
		zoom += 10


func _on_ResetButton_pressed():
	zoom = 100



func _on_TextEdit_focus_entered():
	zoom_button.pressed = false
