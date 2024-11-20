reset()
import numpy

def stimaTeoricaUniFischlin(b):
	"""
	Calcola la stima teorica del numero medio di challenges con valore 1 per la trasformata di Fischlin.
	
	Parametri:
	- b (int): numero di bit del digest dell'hash.

	Ritorna:
	- media (float): valore medio teorico delle challenges con valore 1.
	"""
	foglieAlberello = (b + 5)  # Dimensione di ogni "alberello"
	k = zero_vector(foglieAlberello + 1)  # Vettore per memorizzare numero di 1s
	for i in range(foglieAlberello + 1):
		tmp = 0
		for j in range(i + 1):
			tmp += binomial(foglieAlberello, j)
		k[i] = tmp
	media = 0
	for i in range(1, foglieAlberello + 1):
		media += i * (1 - 2 ** (-b)) ** (k[i - 1]) * (1 - (1 - 2 ** (-b)) ** (k[i] - k[i - 1]))
	return media

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

def testFischlin(L,b):
	"""
	Simula il processo di generazione di una firma con Fischlin, calcolando la query complexity.
	
	Parametri:
	- b (int): numero di bit del digest dell'hash.
	- L (int): numero di round per Fischlin.

	Ritorna:
	- solCounter (vector): vettore dei tentativi necessari per ottenere una soluzione in ciascun round.
	- counter (int): numero totale di query eseguite.
	"""
	counter = 0
	solCounter = zero_vector(L)
	for i in range(L):
		counter2 = 0
		while (randrange(2 ** b) != 0):
			counter += 1
			counter2 += 1
		solCounter[i] = counter2
	return (solCounter, counter)

def testKondi(L, b):
	"""
	Simula il processo di ricerca di collisioni con la tecnica di Kondi, calcolando il numero di query utili.
	
	Parametri:
	- L (int): numero di round considerati.
	- b (int): numero di bit del digest dell'hash.

	Ritorna:
	- usefulQueryes (vector): vettore con i tentativi in cui si trovano collisioni utili.
	- hashQueryKondi (int): numero totale di hash eseguite (i.e. query complexity).
	"""
	usefulQueryes = zero_vector(2 * L)
	hashQueryKondi = 0
	for j in range(L):
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

def testCollision(L, b):
	"""
	Calcola il numero medio di tentativi necessari per ottenere una collisione tra L elementi.
	
	Parametri:
	- L (int): numero di elementi in cui cercare collisioni.
	- b (int): numero di bit del digest dell'hash.

	Ritorna:
	- x[digest] (set): insieme degli elementi che causano collisione.
	- hashQueryKondi (int): numero totale di query per raggiungere la collisione.
	"""
	x = [set() for _ in range(2 ** b)]
	hashQueryKondi = 0
	rowCounter = 0
	while True:
		rowCounter += 1
		for i in range(L):
			hashQueryKondi += 1
			digest = randrange(2 ** b)
			if not(any([coppia[0] == i for coppia in x[digest]])):
				x[digest].add((i, rowCounter))
			if len(x[digest]) >= L:
				return x[digest], hashQueryKondi

# Esecuzione del test per stimare hashCOmplexity e numero di uni nelle tre varianti Fischlin-Plain, Fischlin-Kondi e Fischlin-Collision
numberOfTests = 500
L, b = 16, 8

# Simulazione per Fischlin-Plain
hashQuery = 0
solCounter = zero_vector(L)
for i in range(numberOfTests):
	solCounterTmp, counterTmp = testFischlin(L,b)
	hashQuery += counterTmp / numberOfTests * 1.
	solCounter += solCounterTmp / numberOfTests * 1.

print("*"*50)
print("Fischlin-Plain")
print("hashQuery: ", hashQuery)
numUni = sum([calcolaPesoChallenge(solCounter[i], b + 5) for i in range(L)])
print("Numero di uni: ", numUni)
# Calcolo teorico con formula Fischlin
numeroUniPerBlocco = stimaTeoricaUniFischlin(b)
numeroUniPerFirma = L * numeroUniPerBlocco * 1.
print("numero di uni (teorico)", numeroUniPerFirma)
print("*"*50)

# Simulazione per Fischlin-Kondi
hashQueryKondi = 0
for i in range(numberOfTests):
	x, tmpCollision = testKondi(L / 2, 2 * b)
	hashQueryKondi += tmpCollision / numberOfTests * 1.
	numUni = sum(calcolaPesoChallenge(coppia, b + 5) for coppia in x)

print("Fischiln-Kondi")
print("HashQuery: ", hashQueryKondi)
print("Numero di uni: ", numUni)
print("*"*50)


# Simulazione per la ricerca di collisioni
hashQueryCollision = 0
meanLengthBeforeCollision = 0
for i in range(numberOfTests):
	x, tmpCollision = testCollision(L + 1, b)
	hashQueryCollision += tmpCollision / numberOfTests * 1.
	tmpSum = sum(coppia[1] for coppia in x)
	meanLengthBeforeCollision += tmpSum / numberOfTests * 1.

print("Fischlin-Collision")
print("hashQuery: ", hashQueryCollision)
print("Tentativi ordinati fatti per avere la collisione: ", meanLengthBeforeCollision)
numUni = sum(calcolaPesoChallenge(coppia[1], b + 5) for coppia in x)
print("Numero di uni: ", numUni)
print("*"*50)
