extends Node
# Complex number maths
# Basic functions
# From https://en.wikipedia.org/wiki/Complex_number
static func add(cnum1 : Cnum, cnum2 : Cnum) -> Cnum:
	return Cnum.new(cnum1.real + cnum2.real, cnum1.imag + cnum2.imag)

static func sub(cnum1 : Cnum, cnum2 : Cnum) -> Cnum:
	return Cnum.new(cnum1.real - cnum2.real, cnum1.imag - cnum2.imag)

static func mult(cnum1 : Cnum, cnum2 : Cnum) -> Cnum:
	# Check for real 0's, if non-zero do polar, else do rectangular
	if cnum1.real == 0 or cnum2.real == 0:
		return Cnum.new(cnum1.real * cnum2.real - cnum1.imag * cnum2.imag, cnum1.real * cnum2.imag + cnum1.imag * cnum2.real)
	else:
		var polar1 = __to_polar(cnum1)
		var polar2 = __to_polar(cnum2)
		var r = polar1[0] * polar2[0]
		var gamma = polar1[1] + polar2[1]
		return Cnum.new(r * cos(gamma), r * sin(gamma))

static func divide(cnum2 : Cnum, cnum1 : Cnum) -> Cnum:
	if !((cnum1.real == 0) or (cnum2.real == 0)):
		var polar1 = __to_polar(cnum1)
		var polar2 = __to_polar(cnum2)
		return Cnum.new(polar1[0] / polar2[0] * cos(polar1[1] - polar2[1]), polar1[0] / polar2[0] * sin(polar1[1] - polar2[1]))
	else:
		var scalar = cnum1.real*cnum1.real + cnum1.imag*cnum1.imag
		assert(scalar != 0, "Divide by 0!")
		var real_part = 1 / scalar * (cnum1.real * cnum2.real + cnum1.imag * cnum2.imag)
		var imag_part = 1 / scalar * (cnum1.real * cnum2.imag - cnum1.imag * cnum2.real)
		return Cnum.new(real_part, imag_part)

# More advanced functions
static func recip(cnum : Cnum) -> Cnum:
	var denominator = cnum.real * cnum.real + cnum.imag * cnum.imag
	return Cnum.new(cnum.real/denominator, -cnum.imag/denominator)

static func conj(cnum : Cnum) -> Cnum:
	return Cnum.new(cnum.real, -cnum.imag)

static func csqrt(cnum : Cnum) -> Cnum:
	var polar = __to_polar(cnum)
	var real_part = sqrt(polar[0]) * cos(polar[1] / 2)
	var imag_part = sqrt(polar[0]) * sin(polar[1] / 2)
	return Cnum.new(real_part, imag_part)

static func cexp(cnum : Cnum) -> Cnum:
	# Using Eulers rule
	var real_part = exp(cnum.real) * cos(cnum.imag)
	var imag_part = exp(cnum.real) * sin(cnum.imag)
	return Cnum.new(real_part, imag_part)

static func ln(cnum : Cnum) -> Cnum:
	var polar = __to_polar(cnum)
	return Cnum.new(log(polar[0]), polar[1])

# Utility functions
static func __to_polar(cnum : Cnum) -> Array:
	return [sqrt(cnum.real * cnum.real + cnum.imag * cnum.imag), atan2(cnum.imag, cnum.real)]

static func cabs(cnum : Cnum) -> Cnum:
	var real_part = abs(cnum.real)
	var imag_part = abs(cnum.imag)
	var result = sqrt(real_part*real_part + imag_part*imag_part)
	return Cnum.new(result, 0.0)

static func cpow(cnum: Cnum, power: int) -> Cnum:
	var polar = __to_polar(cnum)
	var real_part = polar[0]^power * cos(power * polar[1])
	var imag_part = polar[0]^power * sin(power * polar[1])
	return Cnum.new(real_part, imag_part)

static func mod(cnum: Cnum) -> Cnum:
	# Same as absolute value, but here for completeness
	var result = sqrt(cnum.real * cnum.real + cnum.imag * cnum.imag)
	return Cnum.new(result, 0.0)

