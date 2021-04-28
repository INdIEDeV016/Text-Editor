extends Control


onready var main = $".."
onready var tween = $Tween
onready var dialogs = get_children()

func _ready():
	main.connect("open_dialog", self, "popup_dialog")
	
	for dialog in dialogs:
		if dialog != tween:
			var err = dialog.connect("popup_hide", self, "hide_dialog", [dialog])
			if err != OK:
				print("%s is not a dialog" % dialog)

func popup_dialog(dialog):
	dialog.popup()
	tween.interpolate_property(
		dialog, "rect_position",
		get_global_mouse_position(), OS.window_size / Vector2(2, 2) - dialog.rect_size / Vector2(2, 2),
		0.5,
		Tween.TRANS_QUINT, Tween.EASE_OUT
	)
	tween.interpolate_property(
		dialog, "rect_scale",
		Vector2.ZERO, Vector2.ONE,
		0.5,
		Tween.TRANS_QUINT, Tween.EASE_OUT
	)
	tween.start()

func hide_dialog(dialog):
	dialog.show()
	tween.interpolate_property(
		dialog, "rect_position",
		OS.window_size / Vector2(2, 2) - dialog.rect_size / Vector2(2, 2), get_global_mouse_position(),
		0.5,
		Tween.TRANS_QUINT, Tween.EASE_OUT
	)
	tween.interpolate_property(
		dialog, "rect_scale",
		Vector2.ONE, Vector2.ZERO,
		0.5,
		Tween.TRANS_QUINT, Tween.EASE_OUT
	)
	tween.start()
	yield(tween, "tween_all_completed")
	dialog.hide()
