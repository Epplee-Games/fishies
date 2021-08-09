extends Node2D

func _ready():
	pass # Replace with function body.

func _draw():
	draw_circle($School.target, 10.0, Color(1.0, 0.5, 1.0))

	# for i in range($School.multimesh.instance_count):
		# var fish = $School.fishes[i]
		# draw_circle(fish.transform[2], fish.seperation_radius, Color(randf(), randf(), randf()))

func _process(delta):
	update()

func draw_circle_only_outline(circle_center, circle_radius, color, resolution, node):
	var draw_counter = 1
	var line_origin = Vector2()
	var line_end = Vector2()
	line_origin = circle_radius + circle_center

	while draw_counter <= 360:
		line_end = circle_radius.rotated(deg2rad(draw_counter)) + circle_center
		node.call('draw_line', line_origin, line_end, color)
		draw_counter += 1 / resolution
		line_origin = line_end

	line_end = circle_radius.rotated(deg2rad(360)) + circle_center
	node.call('draw_line', line_origin, line_end, color)
