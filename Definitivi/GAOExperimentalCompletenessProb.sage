######################## DESCRIPTION #############################
# Given in input $b,\tau,L,s$ computes the completeness error 
# for different values of $L$, in the interval $[L-10,L+10]$
##################################################################

reset()
import numpy


maxTests = 1000 # Number of tests


b_choices = [2,3,4,5,6,7,8]
s_choices = [1,2,3,4,5,6,7]
L_mean = [
	[233,135,104,89,81,76,74],
	[288,156,113,92,79,70,65],
	[398,208,145,112,95,82,73],
	[585,300,210,158,129,111,98],
	[900,450,310,240,195,165,140],
	[1360,750,490,360,303,250,215]
]

def obtainRho(b):
	return ceil(128/b) + 1

def test(b,rho,s,L):
	# generate L * s samples and look for collisions
	table = zero_matrix(s,L)
	for i in range(s):
		for j in range(L):
			table[i,j] = randrange(2^b) + 1
	# count the collisions
	occorrenze = zero_vector(2^b+1)
	for j in range(L):
		occorrenze_tmp = zero_vector(2^b+1)
		for i in range(s):
			if (occorrenze_tmp[table[i][j]] == 0):
				occorrenze_tmp[table[i][j]] += 1
				occorrenze[table[i][j]] += 1
	flag = False
	for occ in occorrenze:
		if occ >= rho:
			flag = True
	#print(occorrenze)
	return flag


for indexB,b in enumerate(b_choices):
	rho = obtainRho(b)
	fileName = "L4CompletenessOneHalf-" + str(b) + "-" + str(rho) + ".dat"
	with open(fileName, "w") as file:
		file.write("Number of test: " + str(maxTests) + "\n")
		file.write("**********\n")
		for indexS,s in enumerate(s_choices):
			#print("Chiavi pubbliche: ", s)
			indexMin = L_mean[indexB][indexS] - 30
			indexMax = L_mean[indexB][indexS] + 30
			for L in range(indexMin, indexMax):
				counter = 0
				noCollisions = 0
				for i in range(maxTests):
					counter +=1
					if (not test(b,rho,s,L)):
						noCollisions += 1
				file.write(
					"b = " + str(b) + ", " 
					"rho = " + str(rho) + ", " 
					"L = " + str(L) + ", " 
					"s = " + str(s) + ", " 
				+ "Prob of no collisions: " 
				+ str(noCollisions / counter * 1.) + "\n")
			file.write("************" + "\n")
	file.close()