extends Interactable

var state = 0

func interact():
	#OS.alert("({}) ball.gd, interact():\ninside interact()" % str(self))
	state += 1
	state = wrap(state, 0, 2)
	#OS.alert("({}) ball.gd, interact():\nstate changed. state = {}" % [str(self), str(state)])
	
	if state == 1:
		#OS.alert("ball.gd, interact():\nstate 1 action")
		$MeshInstance3D.visible = false
		$MeshInstance3D2.visible = true
	elif state == 0:
		#OS.alert("ball.gd, interact():\nstate 0 action")
		$MeshInstance3D.visible = true
		$MeshInstance3D2.visible = false
