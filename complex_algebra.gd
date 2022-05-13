extends Node

# Linear algebra

static func vector(n: int, val: Cnum = Cnum.new(0.0, 0.0)) -> Array:
	var temp = []
	temp.resize(n) # Reshape to the dimension given
	
	for i in range(n):
		temp[i] = val
	
	return temp

static func matrix(n: int, m: int = n, val: Cnum = Cnum.new(0.0, 0.0)) -> Array:
	var temp = []
	temp.resize(n)
	# Row-oriented, as it's easier in my mind with arrays
	for i in range(n):
		var row = []
		row.resize(m)
		for j in range(m):
			row[j] = val
		temp[i] = row
	
	return temp

static func eye(n: int) -> Array:
	var mat = matrix(n)
	
	for i in range(n):
		mat[i][i] = Cnum.new(1.0, 0.0)
	
	return mat

static func add_scalar(input: Array, scalar: Cnum) -> Array:
	var output = input.duplicate(true)
	var n = len(input)
	var m = len(input[0])
	
	for i in range(n):
		for j in range(m):
			output[i][j] = ComplexMaths.add(output[i][j], scalar)
	
	return output

static func add_tensor(A: Array, B: Array) -> Array:
	# Check to make sure A and B are the same size
	var n = len(A)
	var m = len(A[0])
	var o = len(B)
	var p = len(B[0])
	assert(!(n != o or m != p), "A and B must be of same size to add")
	
	var C = matrix(n, m)
	for i in range(n):
		for j in range(m):
			C[i][j] = ComplexMaths.add(A[i][j], B[i][j])
	return C

static func subtract_tensor(A: Array, B: Array) -> Array:
	# Check to make sure A and B are the same size
	var n = len(A)
	var m = len(A[0])
	var o = len(B)
	var p = len(B[0])
	assert(!(n != o or m != p), "A and B must be of same size to add")
	
	var C = matrix(n, m)
	for i in range(n):
		for j in range(m):
			C[i][j] = ComplexMaths.sub(A[i][j], B[i][j])
	return C

static func mult_scalar(input: Array, scalar: Cnum) -> Array:
	var output = input.duplicate(true)
	var n = len(input)
	var m = len(input[0])
	
	for i in range(n):
		for j in range(m):
			output[i][j] = ComplexMaths.mult(output[i][j], scalar)
	
	return output

static func mdot(A: Array, B: Array) -> Array:
	# Check to make sure A and B are appropriately sized
	var n = len(A)
	var m = len(A[0])
	var o = len(B)
	var p = len(B[0])
	assert(!(m != o), "Number of columns in A must match number of rows in B")
	
	var C = matrix(n, p)
	for i in range(m):
		var row = A[i]
		for j in range(o):
			var total = Cnum.new(0.0, 0.0)
			for k in range(n):
				# Check row for array
				var row_num = row
				if typeof(row) == TYPE_ARRAY:
					row_num = row[k]
				
				# Check column for array
				var col = B[k]
				var col_num = col
				if typeof(col) == TYPE_ARRAY:
					col_num = col[j]
				
				var product = ComplexMaths.mult(row_num, col_num)
				total = ComplexMaths.add(total, product)
			C[i][j] = total
	return C

static func vdot(A: Array, B: Array) -> Cnum:
	var n = len(A)
	var m = len(B)
	assert(n == m, "Vectors must be of same length for dot product")
	
	var total = Cnum.new()
	for i in range(n):
		total = ComplexMaths.add(total, ComplexMaths.mult(A[i], B[i]))
	return total

static func mvdot(M: Array, v: Array, v_from_left: bool = true) -> Array:
	var n = len(M)
	var m = len(M[0])
	var output = vector(len(v))
	if v_from_left:
		# Check for compatibility
		assert(len(v) == len(M), "Size of vector must be equal to number of rows in matrix")
		for i in range(m):
			var total = Cnum.new(0.0, 0.0)
			for j in range(m):
				var v_num = v[j]
				var m_num = M[j][i]
				var mult = ComplexMaths.mult(v_num, m_num)
				total = ComplexMaths.add(total, mult)
			output[i] = total
	else:
		# Check for compatibility
		assert(len(v) == len(M[0]), "Size of vector must be equalt to number of columns in matrix")
		for i in range(n):
			var row = M[i]
			var total = Cnum.new(0.0, 0.0)
			for j in range(m):
				var m_num = row[j]
				var v_num = v[j]
				var mult = ComplexMaths.mult(m_num, v_num)
				total = ComplexMaths.add(total, mult)
			output[i] = total
	return output

static func map(cArray: Array, function: Callable) -> Array:
	var output = cArray.duplicate(true)
	if typeof(cArray[0]) == TYPE_ARRAY:
		for i in range(len(cArray)):
			for j in range(len(cArray[0])):
				output[i][j] = function.call(cArray[i][j])
	else:
		for i in range(len(cArray)):
			output[i] = function.call(cArray[i])
	
	return output

static func transpose(cArray: Array) -> Array:
	var output = cArray.duplicate(true)
	for i in range(len(cArray)):
		for j in range(len(cArray[0])):
			output[j][i] = cArray[i][j]
	return output

static func triu(mat: Array) -> Array:
	var n = len(mat)
	
	var output = matrix(n)
	for i in range(n):
		for j in range(i+1, n):
			output[i][j] = mat[i][j]
	return output

static func tril(mat: Array) -> Array:
	var output = mat.duplicate(true)
	output = ComplexAlgebra.transpose(output)
	output = ComplexAlgebra.triu(output)
	return ComplexAlgebra.transpose(output)

static func diag(A) -> Array:
	var n = len(A)
	var output = null
	# If input is a matrix, return a vector. If vector, return matrix.
	if typeof(A[0]) == TYPE_ARRAY:
		output = ComplexAlgebra.vector(n)
		for i in range(n):
			output[i] = A[i][i]
	else:
		output = ComplexAlgebra.matrix(n)
		for i in range(n):
			output[i][i] = A[i]
	return output

static func qrhous(A: Array) -> Array:
	# Computes the QR decomposition A = QR using Householder transformations.
	# The output matrix A contains the householder vectors u and the upper triangle of R.
	# The diagonal of R is stored in vector d.
	# Q is also output here, for conserving and computing eigenvectors.
	var m = len(A)
	var n = len(A[0])
	var A_cols = ComplexAlgebra.transpose(A) # Store the columns as rows, i.e. each array in this is a column
	return []
