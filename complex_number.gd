extends Object
class_name Cnum

var real : float
var imag : float

# Construction
func _init(r_0 : float = 0.0, i_0: float = 0.0) -> void:
	self.real = r_0
	self.imag = i_0

func _to_string() -> String:
	var re = "%.2f" % self.real
	var im = "%.2f i" % self.imag
	var isign = " + "
	if signf(self.imag) == -1:
		isign = " "
	return (re + isign + im)
