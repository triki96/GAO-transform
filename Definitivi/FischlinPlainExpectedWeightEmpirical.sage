########################### DESCRIZIONE ################################################
#	Fissata la coppia (b,rho) t.c. b * rho >= 129,
#  calcoliamo il numero di uni che otterremmo con una proof di Fischlin,
#	in cui abbiamo modificato "L_fischlin" in modo da farlo coincidere con "L_GAO".
########################################################################################

reset()
import numpy


# Input: 	- attempts (int): numero di tentativi effettuati.
#				- t (int): dimensione in bit del chspace del round considerato.
# Output:	- Counter - 1 (int): peso della challenge trovata.
# Descrizione: Calcola il "peso" della challenge trovata, dato il numero di tentativi e la dimensione in bit del chspace.
def calcolaPesoChallenge(attempts, ell):
	if attempts>2^ell:
		return 10^100 # In questo caso ho un completeness error.
	rimanente = attempts
	weight = 0
	while (rimanente > 0):
		rimanente -= binomial(ell, weight)
		weight += 1
	return weight - 1


# 	Input:
# 	- b (int): numero di bit del digest dell'hash.
# 	- L (int): numero di round per Fischlin.
# 	Output:
# 	- solCounter (vector): vettore dei tentativi necessari per ottenere una soluzione in ciascun round.
# 	- counter (int): numero totale di query eseguite.
# Descrizione: simula il processo di generazione di una firma con Fischlin, calcolando la query complexity.
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
# b_vector = [2,3]
# rho_vector = [64,43]

L_vector = [448,344,288,260,242,228,208] # L_FISCHLIN_vector
L_vector=[257,345,513,833,1409,2433,4097] # L_GAO_vector

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
	print("Fischlin-Plain with b=",b ," and rho =",rho)
	numUni = sum([meanWeightVector[i] for i in range(rho)])
	print("Numero di uni: ", numUni)