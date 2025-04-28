########################### Description ################################################
#	Once fixed the pair (b,rho,L) 
#  Compute the number of ones that we obtain with a Fischlin proof
########################################################################################

reset()
import numpy


# Input: - attempts (int): number of attempts made.
# - t (int): size in bits of the chspace of the considered round.
# Output: - Counter - 1 (int): weight of the challenge found.
# Description: Calculates the "weight" of the challenge found, given the number of attempts and the bit size of the chspace.
def calcolaPesoChallenge(attempts, ell):
	if attempts>2^ell:
		return 10^100 # In questo caso ho un completeness error.
	rimanente = attempts
	weight = 0
	while (rimanente > 0):
		rimanente -= binomial(ell, weight)
		weight += 1
	return weight - 1


# Inputs:
# - b (int): Number of hash digest bits.
# - L (int): number of rounds for Fischlin.
# Outputs:
# - solCounter (vector): vector of attempts needed to obtain a solution in each round.
# - counter (int): total number of queries executed.
# Description: simulates the process of generating a signature with Fischlin, calculating the query complexity.
def testFischlin(rho,b):
	solCounter = zero_vector(rho) #determina il numero di challenge tentate per ogni ripetizione (i-esima) 
	for i in range(rho):
		attempts = 1
		while (randrange(2 ** b) != 0):
			attempts += 1
		solCounter[i] = attempts
	return solCounter


numberOfTests = 1000
b_vector = [2,3,4,5,6,7,8]
rho_vector = [64,43,32,26,22,19,16]

choice = "FISCHLIN"
if (choice == "FISCHLIN"):
	print("Computing #1s for Fischlin transform with its original L-value")
	L_vector = [448,344,288,260,242,228,208] # L_FISCHLIN_vector, (rho*b+5)
else:
	print("Computing #1s for Fischlin transform using GAO's L-value")
	L_vector = [257,345,513,833,1409,2433,4097] # L_GAO_vector

ell = [ceil(L_vector[i] /rho_vector[i]*1.) for i in range(len(L_vector))]

for bIndex,b in enumerate(b_vector):
	rho = rho_vector[bIndex]
	#repetitionsGAO=L_vector[bIndex]
	# Simulazione per Fischlin-Plain
	meanWeightVector = zero_vector(rho)
	for i in range(numberOfTests):
		solCounterTmp = testFischlin(rho,b)
		solCounterWeight=[calcolaPesoChallenge(solCounterTmp[i],ell[bIndex]) for i in range(rho)]
		meanWeightVector += vector(solCounterWeight) / numberOfTests * 1.

	print("*"*50)
	print("Fischlin-Plain with b=",b ,"and rho =",rho)
	numUni = sum([meanWeightVector[i] for i in range(rho)])
	print("Experimental number of ones: ", numUni)
