extends Node

var IsBuilding = true

func get_files_in_directory(path: String) -> Array:
	var dir = DirAccess.open(path)
	var files = []
	
	if dir:
		dir.list_dir_begin()  # True per includere sottodirectory, false per non mostrare il percorso completo

		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():  # Verifica che l'elemento sia un file
				files.append(file_name)
			file_name = dir.get_next()
		
		dir.list_dir_end()
	else:
		print("Errore nell'aprire la directory")
	
	return files

func Read_json(FilePath:String):
	var json_as_text = FileAccess.get_file_as_string(FilePath)
	return JSON.parse_string(json_as_text)

func RGB_to_color(RGB:Array):
	return Color(RGB[0] / 255.0, RGB[1] / 255.0, RGB[2] / 255.0)
