class_name Conductor extends Node

@onready var music = $"../AudioStreamPlayer"
@onready var camera = $"../Camera2D"
var time:float = 0 # in ms
var bpm:float = 100
@export var offset:float = 0 # in ms
@export var playback_rate:float = 1.0
var started:bool = false
var bpm_changes:Array[Dictionary] = []

var curBeat:int = 0
var curStep:int = 0

signal on_beat_hit(cur_beat:int)
signal on_step_hit(cur_step:int)

var curDecBeat:float = 0
var curDecStep:float = 0

var camZoom:float = 1

func map_bpm_changes(song:Dictionary) -> void:
	bpm_changes = []
	if (song == null or song.get("events") == null): return
	var cur_bpm:float = song.get("bpm")
	var total_steps:int = 0
	var total_pos:float = 0
	for i in song.get("notes"):
		if (i.get("changeBPM") == null or i.get("bpm") == null): continue
		var cbpm:bool = i.get("changeBPM")
		var newb:float = i.get("bpm")
		if (cbpm == true and newb != cur_bpm):
			cur_bpm = float(i.get("bpm"))
			bpm_changes.append({
				"stepTime": total_steps,
				"songTime": total_pos,
				"bpm": cur_bpm,
				"stepCrochet": float(60 / cur_bpm * 1000)
			})
		var delta_steps:int = roundf(get_section_beats(i) * 4)
		total_steps += delta_steps
		total_pos += ((60 / cur_bpm) * 1000 / 4) * delta_steps;
	var ps = "NEW BPM MAP: "
	for i in bpm_changes:
		ps += str(i) + ", "
	print(ps)

func get_section_beats(arr:Dictionary) -> float:
	if (arr.get("sectionBeats") == null): return 4
	else: return float(arr.get("sectionBeats"))

func get_crochet() -> float:
	return 60 / bpm * 1000
	
func get_step_crochet() -> float:
	return get_crochet() / 4

func load_audio(path:String) -> void:
	var audio:AudioStream = load(path)
	music.stream = audio
	
var BUFFER:float = -1000000;
func set_buffer() -> void:
	BUFFER = -get_crochet() / 250 / playback_rate;

	
func _process(delta) -> void:
	if (not started):
		BUFFER += delta
		time = BUFFER * 1000 + offset
		if (BUFFER < 0): return
		started = true
		music.pitch_scale = playback_rate
		music.play()
	time = (music.get_playback_position() + AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency()) * 1000 + offset
	var oldStep:int = curStep
	var bpm_change:Dictionary = {"stepTime": 0, "songTime": 0, "bpm": 0}
	for event in bpm_changes:
		if (time >= event.get("songTime")):
			bpm_change = event
			break
	var new_bpm:float = bpm_change.get('bpm')
	if (new_bpm > 0 and bpm != new_bpm): bpm = new_bpm
	var st:float = bpm_change.get("stepTime");
	var tm:float = bpm_change.get("songTime");
	curDecStep = st + (time - tm) / get_step_crochet()
	curDecBeat = curDecStep / 4
	curStep = floor(curDecStep)
	curBeat = floor(curDecBeat)
	if (curStep != oldStep): step_hit()
	camZoom = lerpf(1, camZoom, 1 - (delta * 3.125))
	camera.zoom = Vector2(camZoom, camZoom)
	
var steps_hit:Array[int] = []
func step_hit() -> void:
	if (steps_hit.has(curStep)): return
	steps_hit.append(curStep)
	on_step_hit.emit(curStep)
	if (curStep % 4 == 0): beat_hit()
		
func beat_hit() -> void:
	on_beat_hit.emit(curBeat)
	if (curBeat % 4 == 0): camZoom += 0.015;
