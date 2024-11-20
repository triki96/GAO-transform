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


def testCollision(rho, b):
	"""
	Calcola il numero medio di tentativi necessari per ottenere una collisione tra rho elementi.
	
	Parametri:
	- rho (int): numero di round.
	- b (int): numero di bit del digest dell'hash.

	Ritorna:
	- x[digest] (set): insieme degli elementi che causano collisione.
	- hashQueryCollision (int): numero totale di query per raggiungere la collisione.
	"""
	x = [set() for _ in range(2 ** b)]
	hashQueryCollision = 0
	rowCounter = 0
	while True:
		rowCounter += 1 #this determines the challenge I try at every loop for each repetition
		#print("let's try with challenge", rowCounter)
		for i in range(rho):
			hashQueryCollision += 1
			digest = randrange(2 ** b)
			if not(any([coppia[0] == i for coppia in x[digest]])):
				x[digest].add((i, rowCounter))
			if len(x[digest]) >= rho:
				#print("found the collision!",rowCounter," ",hashQueryCollision)
				return x[digest], hashQueryCollision
				

# Esecuzione del test per stimare hashComplexity e numero di uni nella variante  Fischlin-Collsion
numberOfTests = 1000
b, rho = 8, 17 # check: b*(rho-1) >= 128
L = b + 5

# Simulazione per la ricerca di collisioni
hashQueryCollision = 0
meanLengthBeforeCollision = 0
numUni = 0
for i in range(numberOfTests):
	print(i)
	x, tmpCollision = testCollision(rho, b)
	hashQueryCollision += tmpCollision / numberOfTests * 1.
	# tmpSum = sum(coppia[1] for coppia in x)
	# meanLengthBeforeCollision += tmpSum / numberOfTests * 1.
	#[coppia[1] for coppia in x]
	#[calcolaPesoChallenge(coppia[1],L) for coppia in x]
	numUni += sum(calcolaPesoChallenge(coppia[1],L) for coppia in x) / numberOfTests * 1.
	#for coppia in x:
	#	print(coppia[1])
	

# Stampo risultati
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
print(b, " & ", rho, " & ", L," & ", numUni / rho * 1. ," & ",rho * L," & ",numUni," & ", rho * L - numUni, " & ", hashQueryCollision * 1., "\\")
print(separator)
