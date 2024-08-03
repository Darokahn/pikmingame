shader_type canvas_item;

void vertex() {
	
}

void fragment() {
	float magenta = (((sin(TIME*5.0) + 1.0)*0.5)*0.5)+0.5;
	COLOR.r += magenta;
	COLOR.b += magenta;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
