################################### DESCRIPTION ####################################
# This is the code used to build Fig.2 
# Given input (b,rho), the code makes L vary, and for each choice of L it makes
# calculate the completeness probability of GAO with parameters b,rho,s,L.
####################################################################################
reset()

import numpy

# Compute the numero of k-invertible functions defined from [m] to [n]
def countFunctions(k,m,n):
	res = 0
	# Base case
	if (m < 0 or n<0 or k<0):
		return 0
	if (matrix_3d[k][m][n] != -1):
		return matrix_3d[k][m][n]
	
	
	if (k==1):
		if (m > n):
			matrix_3d[k][m][n] = 0
			return 0
		else:
			res = factorial(m) * binomial(n,m)
			matrix_3d[k][m][n] = res
			return res
		
	
	else:	
		# Generic case
		for c in range(floor(m/k)+1):
			tmp1 =  1
			tmp1 = factorial(m) / (factorial(m-k*c) * (factorial(k)^c))
			tmp1 = 1/(factorial(c)) * tmp1
			tmp2 = countFunctions(1,c,n)
			tmp3 = countFunctions(k-1,m-k*c,n-c)
			res += tmp1*tmp2*tmp3
			matrix_3d[k][m][n] = res
	return res

L = 5000 # just to define the matrix independently
rho = 33
b = 4
#s = 1
matrix_3d = [[[-1 for k in range(2^b+1)] for j in range(L+1)] for i in range(rho+1)]

#L = 503
L_max = 2^b * (rho-1) + 1

fileName = "GAOgeneralized-" + str(b) + "-" + str(rho) + ".dat"
with open(fileName, "w") as f:
	f.write("x y\n")
	for i in range(0,L_max+200,50):	
		tmp = (countFunctions(rho-1,i,2^b) / (2^(b*i))) * 1.
		print(i, " - ", log(tmp,2))
		f.write(str(i) + " " + str(1-tmp) + "\n")
f.close()


# tmp = (countFunctions(rho-1,L,2^b) / (2^(b*L))) * 1.
# print(1- tmp)
# print(1- (countFunctions(rho-1,L,2^b) / (2^(b*L)))^s * 1. )
# print(L_max)
# print(1- (countFunctions2(rho-1,L,2^b) / (2^(b*L))) * 1. )

# Poisson approx
# mean = binomial(L,rho)/((2^b)^(rho-1))
# mean = mean * (binomial(L,rho) * factorial(rho))/(L^rho)
# print(1 - exp(-mean * 1.))
# plot(1 - exp(-binomial(x,rho)/((2^b)^(rho-1)) * 1.), (x,100,600))

# Poisson approx
# mean = binomial(L,rho) * s^rho/((2^b)^(rho-1))
# mean = mean * (binomial(L,rho) * factorial(rho))/(L^rho)
# print(1 - exp(-mean * 1.))
# plot(1 - exp(-binomial(x,rho) * s^rho/((2^b)^(rho-1)) * 1.), (x,10,500))