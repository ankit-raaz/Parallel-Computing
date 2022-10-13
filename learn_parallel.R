library(parallel)
?parallel
library(doParallel)
?`doParallel-package`
vignette("gettingstartedParallel")
library(help = "parallel")
detectCores()
cl<- makeCluster(2)
# cl<- makeForkCluster(8)
# stopCluster(cl)
# clusterEvalQ(cl, {library(tidyverse)})
# I used two two cores to do the job
a<-2 
square<- function(num){num**2}
clusterExport(cl, c("a","square"))

clusterEvalQ(cl, {print(c(a,square(a)))})


#This code is in series, counts how much time  lapsed; telling to wait for 3 seconds 5 times and continue
ptm<- proc.time()
 for (i in 1:5){
   Sys.sleep(3)
 }
print(proc.time()-ptm)


#This code in Parallel
ptm<- proc.time()
invisible(parSapply(cl, rep(3,5), Sys.sleep))
# invisble here just hides the null list from Sapply

print(proc.time()-ptm)
stopCluster(cl)
