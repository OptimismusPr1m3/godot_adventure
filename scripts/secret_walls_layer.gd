extends TileMapLayer

func openSecretWall():
	visible = false
	collision_enabled = false
	
func closeSecretWall():
	visible = true
	collision_enabled = true
