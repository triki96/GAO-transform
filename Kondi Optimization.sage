reset()
import numpy

def calcolaPesoChallenge(attempts, t):
	"""
	Calcola il "peso" della challenge trovata, dato il numero di tentativi e la dimensione in bit del chspace.

	Parametri:
	- attempts (int): numero di tentativi effettuati.
	- t (int): dimensione in bit del chspace del round considerato.

	Ritorna:
	- counter - 1 (int): peso della challenge trovata.
	"""
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
		x = [set() for _ in range(2 ** b)]  #a set for each digest
		trovataCoppia = False
		while not trovataCoppia:
			rowCounter += 1  #try a new challenge for each of the two repetitions
			for i in range(2):
				hashQueryKondi += 1 
				digest = randrange(2 ** b) #sample a random digest
				if not(any([coppia[0] == i for coppia in x[digest]])): #in x we have pairs (i,rowcounter) useful to know which challenge we are using
					x[digest].add((i, rowCounter))
				if len(x[digest]) >= 2: #we have the same digest in each of the two repetition. Collision!
					trovataCoppia = True
					usefulQueryes[2 * j] = [coppia[1] for coppia in x[digest]][0]
					usefulQueryes[2 * j + 1] = [coppia[1] for coppia in x[digest]][1]
					#print(usefulQueryes[2 * j]," and ",usefulQueryes[2 * j + 1])
					break
	return usefulQueryes, hashQueryKondi

# Esecuzione del test per stimare hashComplexity e numero di uni nella variante  Fischlin-Kondi
numberOfTests = 500
b, rho = 6, 44 # check: b*rho >= 2*128
L = b/2 + 5

# Simulazione per Fischlin-Kondi
hashQueryKondi = 0
numUni = 0
for i in range(numberOfTests):
	print(i)
	x, tmpCollision = testKondi(rho, b)
	hashQueryKondi += tmpCollision / numberOfTests * 1.
	numUni += sum(calcolaPesoChallenge(coppia, L) for coppia in x) / numberOfTests * 1.

# Stampo risultati
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
print(b, " & ", rho, " & ", L," & ", numUni / rho * 1. ," & ",rho * L," & ",numUni," & ", rho * L - numUni, " & ", hashQueryKondi * 1., "\\")
print(separator)
