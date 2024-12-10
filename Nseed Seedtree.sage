reset()
import numpy

# input: L
# output: b such that b is the number of subtrees 

def min_powers_of_two(L):
	return bin(L).count('1')



#given tau and L returns an upper bound to the number of seeds which will be included in the NIZKP

def compute_Nseed(L,tau):
	u=min_powers_of_two(L)
	return tau*ceil(log(L / tau, 2))+u-1


#computation of the number of seeds in GAO completeness 1.
L=[257,345,513,833,1409,2433,4097] 

#these numbers are greater than the number of GAO because there is a rounding in computing the value \ell

tau=[65,44,33,27,23,20,17]

Nseed=zero_vector(len(tau))

for i in range(len(tau)):
	Nseed[i]=compute_Nseed(L[i],tau[i])
Nseed

weight=zero_vector(len(tau))
for i in range(len(tau)):
	weight[i]=Nseed[i]*16
weight
