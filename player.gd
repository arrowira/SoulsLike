extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var sensitivity = 0.3

@onready var cam_origin: Node3D = $camOriginLeftRight/camOrigin
@onready var lrCam: Node3D = $camOriginLeftRight
func _input(event):
	if event is InputEventMouseMotion:
		#rotate cam left and right
		lrCam.rotate_y(deg_to_rad(-event.relative.x * sensitivity))
		#rotate cam up and down
		cam_origin.rotate_x(deg_to_rad(-event.relative.y * sensitivity))
		cam_origin.rotation.x = clamp(cam_origin.rotation.x,deg_to_rad(-90), deg_to_rad(45))

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
var transY = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.

	


func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_pressed("forward"):
		$MeshInstance3D.rotation.y = lrCam.rotation.y
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (lrCam.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
