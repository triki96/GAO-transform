reset()
import numpy

# Calculate the "weight" of the challenge found, given 
# the number of attempts and the bit size of the chspace.
#
# Parameters:
# - attempts: number of attempts made.
# - t: size in bits of the chspace of the considered round.
#
# Return:
# - counter: weight of the challenge found.
def calcolaPesoChallenge(attempts, t):	
	rimanente = attempts
	counter = 0
	while (rimanente > 0):
		rimanente -= binomial(t, counter)
		counter += 1
	return counter - 1


# 	Calculate the average number of attempts 
#  needed to achieve a collision between rho elements.
#
# 	Parameters:
# 	- rho (int): number of rounds.
# 	- b (int): number of hash digest bits.
#
# 	Return:
# 	- x[digest] (set): set of elements that cause collision.
# 	- hashQueryCollision (int): total number of queries to reach collision.
def testCollision(rho, b):
	x = [set() for _ in range(2 ** b)]
	hashQueryCollision = 0
	rowCounter = 0
	while True:
		rowCounter += 1
		for i in range(rho):
			hashQueryCollision += 1
			digest = randrange(2 ** b)
			if not(any([coppia[0] == i for coppia in x[digest]])):
				x[digest].add((i, rowCounter))
			if len(x[digest]) >= rho:
				return x[digest], hashQueryCollision


# Running the test to estimate hashComplexity 
# and number of ones in the Fischlin-Collsion variant
numberOfTests = 500
b, rho = 8, 17 # check: b*(rho-1) >= 128
L = b + 5

# Simulation for collision detection
hashQueryCollision = 0
meanLengthBeforeCollision = 0
numUni = 0
for i in range(numberOfTests):
	x, tmpCollision = testCollision(rho, b)
	hashQueryCollision += tmpCollision / numberOfTests * 1.
	# tmpSum = sum(coppia[1] for coppia in x)
	# meanLengthBeforeCollision += tmpSum / numberOfTests * 1.
	#[coppia[1] for coppia in x]
	#[calcolaPesoChallenge(coppia[1],L) for coppia in x]
	numUni += sum(calcolaPesoChallenge(coppia[1],L) for coppia in x) / numberOfTests * 1.

separator = "*" * 54
title = "Fischiln-Collision"
print(f"{separator}\n{title:^54}\n{separator}")
print(f"b:            {b}")
print(f"ρ (rho):      {rho}")
print(f"L:            {L}")
print(f"E[W(b)]:      {numUni / rho * 1.}")
print(f"ρ * L:        {rho * L}")
print(f"ρ * E[W(b)]:  {numUni}")
print(f"Seed:         {rho * L - numUni}")
print(f"HashQuery:    {hashQueryCollision * 1.}")
# print(b, " & ", rho, " & ", L," & ", numUni / rho * 1. ," & ",rho * L," & ",numUni," & ", rho * L - numUni, " & ", hashQueryCollision * 1., "\\")
print(separator)
