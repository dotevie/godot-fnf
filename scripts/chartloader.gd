class_name ChartLoader extends Node

@export var song_name = "The Idea"
var song:Dictionary
@onready var Conductor = $"../Conductor"
@onready var strums:Array[Strum] = [$"../Strums/Strum0", $"../Strums/Strum1", $"../Strums/Strum2", $"../Strums/Strum3"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var file = FileAccess.open("res://assets/data/" + song_name + ".json", FileAccess.READ)
	var content = file.get_as_text()
	song = JSON.parse_string(content).get("song")
	for i in song.get("notes"):
		var contains_eligible:bool = false
		for j in i.get("sectionNotes"):
			if (!note_eligible(j[1], i.get("mustHitSection"))):
				i.get("sectionNotes").erase(j)
			else:
				contains_eligible = true
		if (not contains_eligible):
			song.erase(i)
	var bpm:float = song.get('bpm')
	Conductor.bpm = bpm
	Conductor.map_bpm_changes(song)
	Conductor.load_audio("res://assets/music/" + song_name + ".ogg")
	Conductor.set_buffer()
	thread = Thread.new()
	thread.start(note_spawn)
	
var thread:Thread
var should_exit:bool = false

var to_add:Array[Note] = []
func note_spawn():
	while true:
		if (should_exit): break
		for i in song.get("notes"):
			for j in i.get("sectionNotes"):
				if Conductor.time - j[0] * 1.4 < -150 and note_eligible(j[1], i.get("mustHitSection")):
					if (j[1] > 3): j[1] -= 4
					var n = Note.new()
					n.time = j[0]
					n.ID = j[1]
					to_add.append(n)
					i.get("sectionNotes").erase(j);

func _process(delta) -> void:
	for i in to_add:
		strums[i.ID].notes.append(i)
		$"../../Scene".add_child(i)
		to_add.erase(i)

func _exit_tree():
	# Set exit condition to true.
	should_exit = true # Protect with Mutex.
	# Wait until it exits.
	thread.wait_to_finish()
	

@export var opponent_mode:bool = false
func note_eligible(id:int, must_hit:bool) -> bool:
	if (not opponent_mode): return (must_hit and id < 4) or (not must_hit and id > 3)
	else: return (must_hit and id > 3) or (not must_hit and id < 4)
