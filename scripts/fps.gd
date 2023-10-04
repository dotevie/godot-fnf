class_name FPS extends Label

@onready var Conductor = $"../Conductor"
@onready var ChartLoader = $"../ChartLoader"
@onready var RatingManager = $"../RatingManager"

func _ready():
	Conductor.on_step_hit.connect(step_hit)
	# doesn't really need to be every frame

func step_hit(cur_step:int) -> void:
	set_text(str(Engine.get_frames_per_second()) 
	+ " FPS\n" 
	+ formatTime(Conductor.time / 1000 / Conductor.playback_rate) +
	 " / " + formatTime(Conductor.music.stream.get_length() / Conductor.playback_rate) 
	+ "\n" + ChartLoader.song.get("song") + ("" if Conductor.playback_rate == 1 else " (" + str(floor(Conductor.playback_rate * 100) / 100) + "x)")
	+ "\nScore: " + str(RatingManager.score)
	+ "\nMisses: " + str(RatingManager.misses)
	+ "\nAccuracy: " + str(floor(RatingManager.adjusted_notes / RatingManager.total_notes * 10000) / 100) + "%"
	+ "\ncurBeat: " + str(Conductor.curBeat)
	+ "\ncurStep: " + str(Conductor.curStep)
	+ "\nBPM: " + str(Conductor.bpm)
	)


func formatTime(time:float) -> String:
	var mins:int = int(floor(time) / 60)
	var _min:String = str(mins)
	if len(_min) < 2: _min = "0" + _min
	var sec:String = str(floor(time - (mins * 60)))
	if len(sec) < 2: sec = "0" + sec
	return _min + ":" + sec
