extends MultiMeshInstance2D

var target = Vector2(1000.0, 50.0)
var fishes = []
var interspace = 25.0;
var seperation_weight = 0.08
var cohesion_weight = 0.05
var alignment_weight = 0.015

func _ready():
	# multimesh.mesh.material.set_shader_param("mesh_size", multimesh.mesh.get_aabb().size)
	for i in range(multimesh.instance_count):
		var current_fish = Fish.new()
		fishes.push_back(current_fish)
		current_fish.transform = Transform2D().translated(Vector2(randf() * 30.0, i * interspace)) 
		multimesh.set_instance_transform_2d(i, current_fish.transform)

func _process(delta):
	for i in range(self.multimesh.instance_count):
		var fish = fishes[i]

		fish.velocity = (fish.velocity + fish.seek(target)).clamped(fish.max_speed)

		var seperation_force = fish.seperate(fishes).normalized() * seperation_weight
		var coherence_force = fish.cohere(fishes).normalized() * cohesion_weight
		var alignment_force = fish.align(fishes).normalized() * alignment_weight
		var steering = alignment_force + seperation_force + coherence_force

		fish.velocity = (fish.velocity + steering).clamped(fish.max_speed)
		multimesh.set_instance_custom_data(i, Color(fish.velocity.length(), i, 0.0, 0.0))

		var new_transform = Transform2D().rotated(fish.velocity.angle())
		new_transform.origin = Transform2D.IDENTITY.translated(fish.transform.get_origin() + fish.velocity).get_origin()
		fish.transform = new_transform

		multimesh.set_instance_transform_2d(i, fish.transform)

	update()

func _input(event):
	if event is InputEventMouseButton:
		target = event.global_position
		update()

class Fish:
	var transform
	var velocity = Vector2(1.0, 0.0)
	var max_force = 0.05
	var max_speed = 2.5
	var seperation_radius = 100.0

	func seperate(group) -> Vector2:
		var position = transform.get_origin()
		var final_force = Vector2(0.0, 0.0)

		for fish in group:
			var fish_position = fish.transform.get_origin()
			if fish == self:
				continue
			if ((fish_position - position).length() < seperation_radius):
				var force = position - fish_position

				var scaled_force = force.normalized()
				final_force += scaled_force

		return final_force
		
	func cohere(group) -> Vector2:
		var position = transform.get_origin()
		var all_positions = Vector2(0.0, 0.0)
		var amount = 0

		for fish in group:
			var fish_position = fish.transform.get_origin()
			if fish == self:
				continue
			if ((fish_position - position).length() < seperation_radius):
				all_positions += fish_position
				amount += 1

		if (amount != 0):
			return (all_positions / amount) - position

		return Vector2(0.0, 0.0)

	func align(group) -> Vector2:
		var position = transform.get_origin()
		var all_velocities = Vector2(0.0, 0.0)
		var amount = 0

		for fish in group:
			var fish_position = fish.transform.get_origin()
			if fish == self:
				continue
			if ((fish_position - position).length() < seperation_radius):
				all_velocities += fish.velocity.normalized()
				amount += 1

		if (amount != 0):
			var desired_velocity = all_velocities / amount
			var steering = desired_velocity - velocity
			return steering

		return Vector2(0.0, 0.0)

	func seek(point) -> Vector2:
		var desired_velocity = (point - transform.get_origin()).normalized() * max_speed
		var steering = desired_velocity - velocity
		var steering_force = steering.clamped(max_force)
		return steering_force
	
	func flee(point) -> Vector2:
		var desired_velocity = (transform.get_origin() - point).normalized() * max_speed
		var steering = desired_velocity - velocity
		var steering_force = steering.clamped(max_force)
		return steering_force
