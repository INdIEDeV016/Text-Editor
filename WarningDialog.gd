extends WindowDialog


onready var main = $"../.."

func _on_SaveButton_pressed():
	main.save_file()
	if main.current_file == "Untitled":
		yield($"../SaveFileDialog", "file_selected")
	else:
		main.save_file()
	main.open_update_manager()
	


func _on_CancelButton_pressed():
	hide()
