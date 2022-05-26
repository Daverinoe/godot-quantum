extends Node

# Linear algebra

static func random_vector(n: int) -> Tensor:
	randomize()
	var temp = Tensor.new(n)
	
	for i in range(n):
		temp.set_index(Cnum.new(randf()), i)
	return temp


static func eye(n: int) -> Tensor:
	var mat = Tensor.new(n, n)
	
	for i in range(n):
		mat.set_index(Cnum.new(1.0, 0.0), i, i)
	
	return mat


static func add_scalar(input: Tensor, scalar: Cnum) -> Tensor:
	var output = input.duplicate()
	var m = input.m
	var n = input.n
	var o = input.o
	
	for i in range(m):
		for j in range(n):
			for k in range(o):
				output.set_index(ComplexMaths.add(output.get_index(i, j, k), scalar), i, j, k)
	
	return output


static func add_tensor(A: Tensor, B: Tensor) -> Tensor:
	# Check to make sure A and B are the same size
	var m = A.m
	var n = A.n
	var o = A.o
	var p = B.m
	var q = B.n
	var r = B.o
	if (n != p or m != q or o != r):
		push_error("Dimension mismatch!")
	
	var C = Tensor.new(n, m)
	for i in range(m):
		for j in range(n):
			for k in range(o):
				var result = ComplexMaths.add(A.get_index(i, j, k), B.get_index(i, j, k))
				C.set_index(result, i, j, k)
	return C


static func subtract_tensor(A: Tensor, B: Tensor) -> Tensor:
	# Check to make sure A and B are the same size
	var m = A.m
	var n = A.n
	var o = A.o
	var p = B.m
	var q = B.n
	var r = B.o
	if (n != p or m != q or o != r):
		push_error("Dimension mismatch!")
	
	var C = Tensor.new(n, m)
	for i in range(m):
		for j in range(n):
			for k in range(o):
				var result = ComplexMaths.subtract(A.get_index(i, j, k), B.get_index(i, j, k))
				C.set_index(result, i, j, k)
	return C


static func emult(A: Tensor, B: Tensor) -> Tensor:
	# Element-wise multiplication
	if (A.m != B.m or A.n != B.n or A.o != B.o):
		push_error("Dimension mismatch!")
	
	var output = Tensor.new(A.m, A.n, A.o)
	for i in range(A.m):
		for j in range(A.n):
			for k in range(A.o):
				var result = ComplexMaths.mult(A.get_index(i, j, k), B.get_index(i, j, k))
				output.set_index(result, i, j, k)
	return output


static func mult_scalar(A: Tensor, scalar: Cnum) -> Tensor:
	var output = A.duplicate()
	for i in range(A.m):
		for j in range(A.n):
			for k in range(A.o):
				var result = ComplexMaths.mult(output.get_index(i, j, k), scalar)
				output.set_index(result, i, j, k)
	return output


static func divide_scalar(A: Tensor, scalar: Cnum) -> Tensor:
	var output = A.duplicate()
	for i in range(A.m):
		for j in range(A.n):
			for k in range(A.o):
				var result = ComplexMaths.divide(output.get_index(i, j, k), scalar)
				output.set_index(result, i, j, k)
	return output


static func tdot(A: Tensor, B: Tensor) -> Tensor:
	A.printm()
	B.printm()
	if (A.o > 1 or B.o > 1):
		push_error("Matrix multiplication is only defined for Rank 2 tensors at the moment. This is unlikely to change as the dot product of 2 rank 3 tensors is a rank 4 tensor, which isn't supported.")
	# Dot product for matrices
	# Check to make sure A and B are appropriately sized
	# Need to implement robust check based on sizes of tensors TO DO

	var C = Tensor.new(A.n, B.m)
	for i in range(B.m):
		for j in range(A.n):
			var result = Cnum.new(0.0, 0.0)
			for k in range(A.n):
				var a = A.get_index(i, k)
				var b = B.get_index(k, j)
				var inner_result = ComplexMaths.mult(a, b)
				result = ComplexMaths.add(result, inner_result) # May need to look into Kahan summation algorithm if big numbers become a problem.
			C.set_index(result, i, j)
	return C


#static func map(cArray: Array, function: Callable) -> Array:
#	# Take a function and apply it to every element of an vector/ matrix
#	var output = cArray.duplicate(true)
#	if typeof(cArray[0]) == TYPE_ARRAY:
#		for i in range(len(cArray)):
#			for j in range(len(cArray[0])):
#				output[i][j] = function.call(cArray[i][j])
#	else:
#		for i in range(len(cArray)):
#			output[i] = function.call(cArray[i])
#
#	return output
#

#static func transpose(cArray: Array) -> Array:
#	var output = cArray.duplicate(true)
#	for i in range(len(cArray)):
#		for j in range(len(cArray[0])):
#			output[j][i] = cArray[i][j]
#	return output
#

#static func triu(mat: Array) -> Array:
#	# Output the upper triangle of a matrix
#	var n = len(mat)
#
#	var output = matrix(n)
#	for i in range(n):
#		for j in range(i+1, n):
#			output[i][j] = mat[i][j]
#	return output
#

#static func tril(mat: Array) -> Array:
#	# Output the lower triangle of a matrix
#	var output = mat.duplicate(true)
#	output = transpose(output)
#	output = triu(output)
#	return transpose(output)
#

#static func diag(A) -> Array:
#	var n = len(A)
#	var output = null
#	# If input is a matrix, return a vector. If vector, return matrix.
#	if typeof(A[0]) == TYPE_ARRAY:
#		output = vector(n)
#		for i in range(n):
#			output[i] = A[i][i]
#	else:
#		output = matrix(n)
#		for i in range(n):
#			output[i][i] = A[i]
#	return output
#

#static func qrhous(A: Array) -> Array:
#	# Computes the QR decomposition A = QR using Householder transformations.
#	# The output matrix A contains the householder vectors u and the upper triangle of R.
#	# The diagonal of R is stored in vector d.
#	# Q is also output here, for conserving and computing eigenvectors.
#	var m = len(A)
#	var n = len(A[0])
#	var d = vector(n)
#	var A_cols = transpose(A) # Store the columns as rows, i.e. each array in this is a column
#	for j in range(n):
#		var Ajm = A_cols[j].slice(j, m)
#		var s = norm(Ajm)
#		assert(!(s.real == 0 and s.imag == 0), "rank(A) < n")
#		d[j] = s
#		if A[j][j].real >= 0 or A[j][j].imag >= 0:
#			d[j] = ComplexMaths.mult(Cnum.new(-1, 0.0), s) # Make negative
#		var fak = ComplexMaths.csqrt(ComplexMaths.mult(s, ComplexMaths.add(s, ComplexMaths.abs(A[j][j]))))
#		A[j][j] = ComplexMaths.sub(A[j][j], d[j])
#		var temp_col = divide_scalar(Ajm, fak)
#		for row in range(j, m):
#			A[row][j] = temp_col[row-j]
#
#	return []
#

#static func norm(A: Array) -> Cnum:
#	# Return the norm of a vector.
#	# Implement returning 2-norm for matrices later
#	var n = len(A)
#	assert(typeof(A[0]) != TYPE_ARRAY, "Matrix norms not yet supported. Use only vectors.")
#	var total = Cnum.new(0.0, 0.0)
#	for i in range(n):
#		var sqr = ComplexMaths.mult(ComplexMaths.conj(A[i]), A[i])
#		total = ComplexMaths.add(total, sqr)
#	var result = ComplexMaths.csqrt(total)
#	return result
#


## From https://github.com/higgs-bosoff
#static func eig_pow(A: Tensor, tol: float = 1e-5) -> Array:
#	var n = A.m
#	var M = A.duplicate()
#
#	var evals = []
#	var evecs = []
#
#	evals.resize(n)
#	evecs.resize(n)
#
#	for k in range(n):
#		# Start with a random vector
#		var v0 = random_vector(n)
#		var e0 = 0
#		var v1
#		var e1
#		for t in range(100):
#			v1 = mvdot(M, v0, false)
#			e1 = norm(v1)
#			v1 = emult(v1, 1.0/e1)
#			if abs(e1-e0) < tol:
#				# Sign fix
#				e1 *= vdot(v0, v1)
#				break
#			e0 = e1
#			v0 = v1
#		evals[k] = e1
#		evecs[k] = v0
#
#		# Shift
#		for i in range(n):
#			var row = M[i]
#			var vi = v0[i]
#			for j in range(n):
#				row[j] -= e1*vi*v0[j]
#
#	return [evals, evecs]
