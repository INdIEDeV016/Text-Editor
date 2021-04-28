extends Node


onready var settings = {
	"theme":"light",
	"is_whats_new_seen":false,
}


func save_settings():
	var f = File.new()
	var err = f.open("user://Settings.cfg", File.WRITE)
	if err == OK:
		f.store_var(settings)
	

func load_settings():
	var f = File.new()
	var err = f.open("user://Settings.cfg", File.READ)
	if err == OK:
		settings = f.get_var(true)
