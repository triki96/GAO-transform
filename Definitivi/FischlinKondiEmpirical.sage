reset()
import numpy


# Calculate the "weight" of the challenge found, given the number of attempts and the bit size of the chspace.

# Parameters:
# - attempts (int): number of attempts made.
# - t (int): size in bits of the chspace of the considered round.

# Return:
# - counter - 1 (int): weight of the challenge found.
def calcolaPesoChallenge(attempts, t):
	rimanente = attempts
	counter = 0
	while (rimanente > 0):
		rimanente -= binomial(t, counter)
		counter += 1
	return counter - 1


def testKondi(rho, b):
	usefulQueryes = zero_vector(rho)
	hashQueryKondi = 0
	for j in range(rho/2):
		rowCounter = 0
		x = [set() for _ in range(2 ** b)]
		trovataCoppia = False
		while not trovataCoppia:
			rowCounter += 1
			for i in range(2):
				hashQueryKondi += 1
				digest = randrange(2 ** b)
				if not(any([coppia[0] == i for coppia in x[digest]])):
					x[digest].add((i, rowCounter))
				if len(x[digest]) >= 2:
					trovataCoppia = True
					usefulQueryes[2 * j] = [coppia[1] for coppia in x[digest]][0]
					usefulQueryes[2 * j + 1] = [coppia[1] for coppia in x[digest]][1]
					break
	return usefulQueryes, hashQueryKondi

# Running the test to estimate hashComplexity and 
# number of ones in the Fischlin-Kondi variant
numberOfTests = 500
b, rho = 16, 16 # check: b*rho >= 2*128
L = b/2 + 5

# Simulation for Fischlin-Kondi
hashQueryKondi = 0
numUni = 0
for i in range(numberOfTests):
	print(i)
	x, tmpCollision = testKondi(rho, b)
	hashQueryKondi += tmpCollision / numberOfTests * 1.
	numUni += sum(calcolaPesoChallenge(coppia, L) for coppia in x) / numberOfTests * 1.

separator = "*" * 54
title = "Fischiln-Kondi"
print(f"{separator}\n{title:^54}\n{separator}")
print(f"b:            {b}")
print(f"ρ (rho):      {rho}")
print(f"L:            {L}")
print(f"E[W(b)]:      {numUni / rho:.2f}")
print(f"ρ * L:        {rho * L}")
print(f"ρ * E[W(b)]:  {numUni}")
print(f"Seed:         {rho * L - numUni}")
print(f"HashQuery:    {hashQueryKondi * 1.}")
print(separator)
# print(b, " & ", rho, " & ", L," & ", numUni / rho * 1. ," & ",rho * L," & ",numUni," & ", rho * L - numUni, " & ", hashQueryKondi * 1., "\\")
print(separator)
