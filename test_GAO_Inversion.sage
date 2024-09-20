#GAO INVERSION OF RANDOM ORACLE
#combine GAO stateful and multiple keys (set alpha=40 if you want a single repetition, s=1 if you want a single key)

reset()
import numpy

# security parameter
secPar=128

#completeness error on the single repetition
alpha= 4

# number of public keys, so the challenge space has cardinality s+1
s=7

#number of target components in a signature
rho = 25

#min_r number of repetitions to guarantee an overall completeness error 2^(-40)
r= ceil(40/alpha)



# SCOPE: compute the product b*rho so that the soundness is guaranteed 
#input:alpha, r, secPar
#output:b*rho


#determino il prodotto b*rho che deve essere >= a secPar
bRho=secPar
def checkCond1(bRho):
	if (1-(1-2^(-bRho))^r <= 2^(-secPar)):
		return True
	else:
		return False
		
while(not checkCond1(bRho)):
	print(bRho)
	bRho += 1


#values obtained: (secPar,alpha,r)=(128,8,5) ->bRho=131
#		  (secPar,alpha,r)=(128,4,10)->bRho=132
#		  (secPar,alpha,r)=(128,2,20)->bRho=133 
#		  (secPar,alpha,r)=(128,1,40)->bRho=134



#--------------------------------------------------------------------------------------------

#input: alpha,r,b,rho, s
#output: trova min_L per avere completeness error 2^(-alpha)


#probabilità di essere target element 2^b
#setto b in funzione di rho, può essere anche un razionale.

b =  bRho/rho

#probability that a specific challenge+response does not yelds 0^b

probFailSingleChallenge=(2^(b)-1)/2^b

#probability that an element is a potential target component (exists a challenge such that the verification yelds 0^b)

probTarget= 1 - ( probFailSingleChallenge )^s


#number of first messages in each repetition
def checkCond2(L):
	count = 0
	for i in range(rho):
		count += binomial(L,i) * (probTarget)^i *  (1-probTarget)^(L-i)
		#print(count * 1.)
	if (count <= 2^(-alpha)):
		return True
	else:
		return False
		
#number of first messages (parallel executions of the sigma protocol) in each repetition
min_L = rho
		
while(not checkCond2(min_L)):
	print(min_L)
	min_L += 1
	
	
#per valori: (secPar,alpha,r)=(128,4,10) -> bRho=132 therefore (secPar,alpha,s,r,rho,b)=(128,4,3,10,32,132/32) -> min_L= 247
#            (secPar,alpha,r)=(128,4,10) -> bRho=132 therefore (secPar,alpha,s,r,rho,b)=(128,4,3,10,25,132/32) -> min_L= 435
