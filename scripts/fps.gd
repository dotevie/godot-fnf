class_name FPS extends Label

@onready var Conductor = $"../Conductor"
@onready var ChartLoader = $"../ChartLoader"
@onready var RatingManager = $"../RatingManager"

func _process(_delta) -> void:
	set_text(str(Engine.get_frames_per_second()) 
	+ " FPS\n" 
	# + formatTime(Conductor.time / 1000 / Conductor.playback_rate) +
	#  " / " + formatTime(Conductor.music.stream.get_length() / Conductor.playback_rate) 
	# + "\n" + ChartLoader.song.get("song") + ("" if Conductor.playback_rate == 1 else " (" + str(floor(Conductor.playback_rate * 100) / 100) + "x)")
	# + "\nScore: " + str(RatingManager.score)
	# + "\nMisses: " + str(RatingManager.misses)
	# + "\nAccuracy: " + str(floor(RatingManager.adjusted_notes / RatingManager.total_notes * 10000) / 100) + "%"
	# + "\ncurBeat: " + str(Conductor.curBeat)
	# + "\ncurStep: " + str(Conductor.curStep)
	# + "\nBPM: " + str(Conductor.bpm)
	)
