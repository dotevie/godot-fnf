class_name FPS extends Label

@onready var Conductor = $"../Conductor"
@onready var ChartLoader = $"../ChartLoader"
@onready var RatingManager = $"../RatingManager"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	set_text(str(Engine.get_frames_per_second()) 
	+ " FPS\n" 
	+ formatTime(Conductor.time / 1000) +
	 " / " + formatTime(Conductor.music.stream.get_length()) 
	+ "\n" + ChartLoader.song.get("song")
	+ "\nScore: " + str(RatingManager.score)
	+ "\nMisses: " + str(RatingManager.misses)
	+ "\nAccuracy: " + str(floor(RatingManager.adjusted_notes / RatingManager.total_notes * 10000) / 100) + "%"
	+ "\ncurBeat: " + str(Conductor.curBeat)
	+ "\ncurStep: " + str(Conductor.curStep)
	)


func formatTime(time:float) -> String:
	var mins:int = int(floor(time) / 60)
	var min:String = str(mins)
	if len(min) < 2: min = "0" + min
	var sec:String = str(floor(time - (mins * 60)))
	if len(sec) < 2: sec = "0" + sec
	return min + ":" + sec
