reset()
import numpy

# input: L
# output: b such that b is the number of subtrees 

def min_powers_of_two(L):
	return bin(L).count('1')



#given tau and L returns an upper boun to the number of seeds which will be included in the NIZKP

def compute_Nseed(L,tau):
	u=min_powers_of_two(L)
	return tau*ceil(log(L / tau, 2))+u-1
	
#computation of the number of seeds
L, tau= 4097, 17
Nseed=compute_Nseed(L,tau)
Nseed
