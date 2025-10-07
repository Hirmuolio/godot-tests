extends Label

var rolling_frametime : Array[float]
var avg_period : int = 10

func _ready() -> void:
	rolling_frametime.resize( avg_period )
	rolling_frametime.fill( 0 )

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#var fps : float = Engine.get_frames_per_second()
	var fps : float = (1/delta)
	
	
	rolling_frametime.push_back( delta )
	rolling_frametime.pop_front()
	var avg_fps : float = avg_period / rolling_frametime.reduce(sum,)
	
	text = "FPS: %.3f\n FPS: %.3f (averaged)" % [fps,avg_fps]
	pass

func sum(accum : float, number : float)->float:
	return accum + number
