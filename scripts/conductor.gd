class_name Conductor extends Node

@onready var music = $"../AudioStreamPlayer"
@onready var camera = $"../Camera2D"
var time:float = 0 # in ms
var bpm:float = 100
@export var offset:float = 0 # in ms
@export var playback_rate:float = 1.0
var started:bool = false

var curBeat:int = 0
var curStep:int = 0

var curDecBeat:float = 0
var curDecStep:float = 0

var camZoom:float = 1

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
	curDecStep = time / get_step_crochet()
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
	if (curStep % 4 == 0): beat_hit()
		
func beat_hit() -> void:
	if (curBeat % 4 == 0): camZoom += 0.015;
