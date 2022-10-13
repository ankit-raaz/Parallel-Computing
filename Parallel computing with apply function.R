
#Before running parallel programming, we need to establish declare nodes to do the work. 
# The parallel::detectCores() function detects how many nodes are available.
# The parallel::makeCluster() function declares which nodes will be used in the parallel programming.
n_detectCores<- parallel::detectCores()
v_n<- rep(1e5,1e4)
list_system.time<-list()
cl<-parallel::makeCluster(
   spec = n_detectCores
)
# We will generate a lot of random normal data. we will repeat this using multiple parallel apply functions.
# Then we will compare the computation time


##ClusterApply

list_system.time[["clusterApply"]]<- system.time(
  expr = {
    parallel::clusterApply(
      cl=cl,
      x=v_n,
      fun=rnorm
    )
  }
)

parallel::stopCluster(
  cl=cl
)
