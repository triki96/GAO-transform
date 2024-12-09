########################### Description ################################################
#	Once fixed the pair (b,rho,L) 
#  Compute the number of ones that we obtain with a Fischlin proof
########################################################################################

reset()
import numpy


# Calculate the theoretical estimate of the average number of challenges with value 1 for the Fischlin transform.
#
# Parameters:
# - b (int): number of hash digest bits.
#
# Return:
# - average (float): theoretical average value of the challenges with value 1.
def stimaTeoricaUniFischlin(b):
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


b_vector = [2,3,4,5,6,7,8]
rho_vector = [64,43,32,26,22,19,16]

# L_vector = [448,344,288,260,242,228,208] # L_FISCHLIN_vector
# L_vector = [257,345,513,833,1409,2433,4097] # L_GAO_vector

# ell = [ceil(L_vector[i] /rho_vector[i]*1.) for i in range(len(L_vector))]

for bIndex,b in enumerate(b_vector):
	rho = rho_vector[bIndex]
	numOnes = stimaTeoricaUniFischlin(b)
	meanOnes = rho * numOnes
	print("*"*50)
	print("Fischlin-Plain with b=",b ," and rho =",rho)
	print("Numero di uni: ", meanOnes * 1.)