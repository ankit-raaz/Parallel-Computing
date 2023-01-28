library(ecospace)
data("KWTraits")
nchar<-18
char.state<-c(2,7,3,3,2,2,5,5,2,5,2,2,5,2,5,5,3,3)

char.type<-c("numeric", "ord.num", "numeric", "numeric", "numeric", "numeric",
             "ord.num", "ord.num", "numeric", "ord.num", "numeric", "numeric", "ord.num",
             "numeric", "ord.num", "numeric", "numeric", "numeric")

char.names <- c("Reproduction", "Size", "Substrate composition", "Substrate
consistency", "Supported", "Attached", "Mobility", "Absolute tier", "Absolute
microhabitat", "Relative tier", "Relative microhabitat", "Absolute food
microhabitat", "Absolute food tier", "Relative food microhabitat", "Relative
food tier", "Feeding habit", "Diet", "Food condition")

state.names <- c("SEXL", "ASEX", "BVOL", "BIOT", "LITH", "FLUD", "HARD", "SOFT",
                 "INSB", "SPRT", "SSUP", "ATTD", "FRLV", "MOBL", "ABST", "AABS", "IABS", "RLST",
                 "AREL", "IREL", "FAAB", "FIAB", "FAST", "FARL", "FIRL", "FRST", "AMBT", "FILT",
                 "ATTF", "MASS", "RAPT", "AUTO", "MICR", "CARN", "INCP", "PART", "BULK")

ecospace<- create_ecospace(nchar,char.state,char.type,char.names,
                           state.names,constraint = 2,
                           weight.file = KWTraits)


library(doParallel)
ncores<- detectCores()

nreps <- 1:1000
system.time(
  {
#Neutral Model -1 
n.samples <- mclapply(X = nreps, FUN = neutral, Sseed = 5, Smax = 100, ecospace, mc.cores = ncores)
n.metrics <- mclapply(X = nreps, FUN = calc_metrics, samples = n.samples,
                  Model = "Neutral", Param = "1",  mc.cores = ncores)
n.all <- rbind_listdf(n.metrics)
library("beepr")
beep(6)
write.table(n.all, "Neutral.csv")
})

rm(n0.5.samples)

system.time(
  {
#Expansion Model-1
e.samples <- mclapply(X = nreps, FUN = ecospace::expansion, Sseed = 5, Smax = 100, ecospace, mc.cores = ncores)
e.metrics <- mclapply(X = nreps, FUN = calc_metrics, samples = e.samples,
                      Model = "Expansion", Param = "1",  mc.cores = ncores)
e.all <- rbind_listdf(e.metrics)
library("beepr")
beep(6)
write.table(e.all, "Expansion.csv")
})


system.time(
  {
    #Expansion Model-0.5 h, stands for half
    eh.samples <- mclapply(X = nreps, FUN = ecospace::expansion, Sseed = 5, Smax = 100, ecospace,strength=0.5, mc.cores = ncores)
    eh.metrics <- mclapply(X = nreps, FUN = calc_metrics, samples = eh.samples,
                          Model = "Expansion-1", Param = "0.5",  mc.cores = ncores)
    eh.all <- rbind_listdf(eh.metrics)
    library("beepr")
    beep(6)
    write.table(eh.all, "Expansion-0.5.csv")
  })


system.time(
  {
# Redundancy model
red1.samples <- mclapply(X = nreps, FUN = redundancy, Sseed = 5, Smax = 100, ecospace, mc.cores = ncores)
red1.metrics <- mclapply(X = nreps, FUN = calc_metrics, samples = red1.samples,
                      Model = "Redundancy-1", Param = "1",  mc.cores = ncores)

r.all <- rbind_listdf(red1.metrics)

library("beepr")
beep(6)
write.table(r.all, "Redundancy.csv")
})

system.time({
# Strict Partitioning model
PartS.samples <- mclapply(X = nreps, FUN = partitioning, Sseed = 5, Smax = 100, ecospace, rule= "strict", mc.cores = ncores)
PartS.metrics <- mclapply(X = nreps, FUN = calc_metrics, samples = PartS.samples,
                         Model = "PartitioningS", Param = "1",  mc.cores = ncores)
PartS.all <- rbind_listdf(PartS.metrics)
library("beepr")
beep(6)
write.table(PartS.all, "PartitioningS.csv")
})

system.time({
# Partitioning Model Relaxed
  PartR.samples <- mclapply(X = nreps, FUN = partitioning, Sseed = 5, Smax = 100, ecospace, rule= "relaxed", mc.cores = ncores)
  PartR.metrics <- mclapply(X = nreps, FUN = calc_metrics, samples = PartR.samples,
                            Model = "PartitioningR", Param = "1",  mc.cores = ncores)
  
PartR.all <- rbind_listdf(PartR.metrics)
library("beepr")
beep(6)
write.table(PartR.all, "PartitioningR.csv")
})

tree.input.100<-rbind(n.all, e.all,r.all,PartS.all,PartR.all)

write.table(tree.input.100,"tree.input.100.csv" )

#saving this workspace
# save.image(file= "/home/paleolab/Desktop/Paleobiology lab/Codes/Repro/workspace.RData")
# history(file= "/home/paleolab/Desktop/Paleobiology lab/Codes/Repro/workspace.Rhistory")


