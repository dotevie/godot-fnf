class_name TimeText extends Label

@onready var Conductor = $"../Conductor"

func _process(_delta):
	text = format_time(Conductor.time / 1000 / Conductor.playback_rate) + " / " + format_time(Conductor.music.stream.get_length() / Conductor.playback_rate)


func format_time(time:float) -> String:
	if (time < 0): return "00:00"
	var mins:int = int(floor(time) / 60)
	var _min:String = str(mins)
	if len(_min) < 2: _min = "0" + _min
	var sec:String = str(int(floor(time - (mins * 60))))
	if len(sec) < 2: sec = "0" + sec
	return _min + ":" + sec
