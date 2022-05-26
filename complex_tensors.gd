extends Object
class_name Tensor

# The tensor class will support up to rank 3 tensors
# Row-ordered tensors, as arrays are easier like that.

var m : int = 0 # Rows
var n : int = 0 # Columns
var o : int = 0 # Slices

var __tensor : Array # The tensor, private, should not be directly accessed.

func _init(set_m : int, set_n : int = 1, set_o : int = 1) -> void:
	# Vectors don't need to be a row or column, so if you want a vector, just set m.
	m = set_m
	n = set_n
	o = set_o
	if (n > m and o == 1 and m == 1):
		m = n
		n = 1
	
	# Make 3-D matrix
	self.__tensor.resize(m)
	# Row-oriented, as it's easier in my mind with arrays
	for i in range(m):
		var row = []
		row.resize(n)
		for j in range(n):
			self.__tensor[i] = row
			var slice = []
			slice.resize(o)
			for k in range(o):
				slice[k] = Cnum.new(0.0, 0.0)
			self.__tensor[i][j] = slice

func set_index(value, m_index : int = 0, n_index : int = 0, o_index : int = 0) -> void:
	self.__tensor[m_index][n_index][o_index] = value

func get_index(m_index : int = 0, n_index : int = 0, o_index : int = 0) -> Cnum:
	return self.__tensor[m_index][n_index][o_index]

func set_multiple_indices(values : Tensor, m_indices : Array = [0], n_indices : Array = [0], o_indices : Array = [0]) -> void:
	var m_size = m_indices.size()
	var n_size = n_indices.size()
	var o_size = o_indices.size()
	
	# Error checks
	if m_indices.size() != values.m or n_indices.size() != values.n or o_indices.size() != values.o:
		push_error("Indices must match value dimensions.")
	if (n == 1 and n_size > 1) or (o == 1 and o_size > 1):
		push_error("Indices will be out of bounds.")
	
	for i in range(m_size):
		for j in range(n_size):
			for k in range(o_size):
				self.__tensor[m_indices[i]][n_indices[j]][o_indices[k]] = values.__tensor[i][j][k]

func get_multiples_indices(m_indices : Array = [0], n_indices : Array = [0], o_indices : Array = [0]) -> Tensor:
	var m_size = m_indices.size()
	var n_size = n_indices.size()
	var o_size = o_indices.size()
	var output = Tensor.new(m_size, n_size, o_size) # New Tensor to hold indices
	
	for i in range(m_size):
		var local_m = m_indices[i]
		for j in range(n_size):
			var local_n = n_indices[j]
			for k in range(o_size):
				output.set_index(self.get_index(local_m, local_n, o_indices[k]), i, j, k)
	
	return output

func size() -> Array:
	return [m, n, o]

func duplicate() -> Tensor:
	var output = Tensor.new(n, m, o)
	output.m = self.m
	output.n = self.n
	output.o = self.o
	output.__tensor = self.__tensor.duplicate(true)
	return output

func printm() -> void:
	# Print matrices with the rows on top of one-another
	# So that they're easier to diagnose.
	for k in range(o):
		var pstr = ""
		for i in range(m):
			pstr += "|"
			for j in range(n):
				if j == n - 1:
					pstr += str(self.get_index(i, j, k))
				else:
					pstr += str(self.get_index(i, j, k)) + ", "
			pstr += "|\n"
		print(pstr)
