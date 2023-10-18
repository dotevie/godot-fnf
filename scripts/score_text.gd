class_name ScoreText extends Label

@onready var RatingManager = $"../RatingManager"
@onready var Conductor = $"../Conductor"
var scale_tween:Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	RatingManager.on_hit.connect(func():
		if (scale_tween): scale_tween.kill()
		scale_tween = create_tween()
		scale = Vector2(1.1, 1.1)
		scale_tween.tween_property(self, "scale", Vector2.ONE, 0.25)
		do_score()
	)
	RatingManager.on_miss.connect(do_score)

func do_score():
	text = "Score: " + str(RatingManager.score) + " \\ Misses: " + str(RatingManager.misses) + " \\ Accuracy: " + str(floor(RatingManager.adjusted_notes / RatingManager.total_notes * 10000) / 100) + "%"
