import multiprocessing 

result =[]

def calc_square (numbers) :
	global result
	for n in numbers:
		result.append(n*n)
	print('inside process' + str(result))
	
if __name__ == "__main__" :
	numbers = [2,3,5]
	p= multiprocessing.Process(target= calc_square, args= (numbers,))
	
	p.start()
	p.join()
	
	print('outside process' + str(result))
