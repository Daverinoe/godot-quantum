extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var cnum = Cnum.new(1, 1)
	var cnum2 = Cnum.new(5, -4)
	print("Complex number 1:")
	print(cnum)
	print("Complex number 2:")
	print(cnum2)
	print("Addition:")
	print(ComplexMaths.add(cnum, cnum2))
	print("Subtraction:")
	print(ComplexMaths.sub(cnum, cnum2))
	print("Multiplication")
	print(ComplexMaths.mult(cnum, cnum2))
	print("Division:")
	print(ComplexMaths.divide(cnum, cnum2))
	print("Reciprocal:")
	print(ComplexMaths.recip(cnum2))
	print("Conjugation:")
	print(ComplexMaths.conj(cnum2))
	print("Square root:")
	print(ComplexMaths.csqrt(cnum2))
	print("Exponential:")
	print(ComplexMaths.cexp(cnum2))
	print("Natural log:")
	print(ComplexMaths.ln(cnum2))
	
	var vec1 = ComplexAlgebra.vector(2, Cnum.new(1.0, 0.0))
	var vec2 = ComplexAlgebra.vector(2, Cnum.new(2.0, 1.0))
	vec2[1] = ComplexMaths.add(vec2[1], Cnum.new(-4.0, 1.0))
	var mat1 = ComplexAlgebra.matrix(2, 2, Cnum.new(2.0, -2))
	var mat2 = ComplexAlgebra.matrix(2, 2, Cnum.new(1.0, 1.0))
	var eye = ComplexAlgebra.eye(2)
	var add_scalar = ComplexAlgebra.add_scalar(eye, Cnum.new(2.0, 0.0))
	var add_tensor = ComplexAlgebra.add_tensor(mat1, eye)
	add_tensor[0][1] = ComplexMaths.add(add_tensor[0][1], Cnum.new(3.0, -1.0))
	var add_tensor2 = ComplexAlgebra.add_tensor(mat2, eye)
	var mdot_product = ComplexAlgebra.mdot(add_tensor, add_tensor2)
	var vdot_product = ComplexAlgebra.vdot(vec1, vec2)
	var left_mvdot_product = ComplexAlgebra.mvdot(add_tensor, vec2)
	var right_mvdot_product = ComplexAlgebra.mvdot(add_tensor, vec2, false)
	var triu = ComplexAlgebra.triu(ComplexAlgebra.matrix(4, 4, Cnum.new(2.0, 0.0)))
	var tril = ComplexAlgebra.tril(ComplexAlgebra.matrix(4, 4, Cnum.new(2.0, 0.0)))
	var diag1 = ComplexAlgebra.diag(mdot_product)
	var diag2 = ComplexAlgebra.diag(vec2)
	var conj_map = ComplexAlgebra.map(mdot_product, ComplexMaths.conj)
	print(mdot_product)
	print(conj_map)
