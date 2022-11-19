import matplotlib.pyplot as plt

# Initialize dictionaries
execTimePerThreadCount = {1:32.281474, 2:28.919362, 4:9.415138, 8:7.848384, 16:6.327052, 32:6.460092}
speedupPerThreadCount = {1:0.9100342506045417, 2:1.0158331639543086, 4:3.120214169988799, 8:3.743095011660999, 16:4.643117679450082,32:4.5474966919975754}
execTimePerInputSize = {2000:6.285181, 4000:19.751454, 6000:37.916212, 8000:62.966194, 10000:98.147043}
execTimePerDataPoint= {4000000:6.285181,16000000:19.751454,36000000:37.916212,64000000:62.966194, 100000000:98.147043}

serialTime = 29.377247;








# Plot execution time per thread count
plt.xlabel("Data Point")
plt.ylabel("Running Time (sec)")
lists = sorted(execTimePerDataPoint.items()) # sorted by key, return a list of tuples
x, y = zip(*lists) # unpack a list of pairs into two tuples
plt.plot(x, y)
plt.show()







