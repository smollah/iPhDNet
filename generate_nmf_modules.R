# ----------------------------------------------------------------------------
# Author: Shamim Mollah  
# Created: 12-10-2016
# 
# Generate functional modules using NMF
#-----------------------------------------------------------------------------

library(NMF)

#set directory
setwd("/Users/smollah")
rm(list = ls())
histon_data<-read.table("60histone_24hr.txt", sep="\t", header=T, row.names=1)

identify_optimal_factorization_rank <- function(mat_hist) {
  #to identify optimal factorization rank
  V.random <- randomize(mat_hist)
  estim.r.random <- nmf(V.random, 2:10, nrun = 1000, seed = 123456)
  estim.r <- nmf(mat_hist, 2:10, nrun = 1000, seed = 123456)
  #plot(estim.r, estim.r.random)
  #...add steps to extract k from graph
  #k
}

generate_nmf_modules <- function(histon_data) {

  YNormZ<-scale(as.matrix(histon_data[,]))

  #Normalized Data to [0,1]
  fun <- function(x){ 
       a <- min(x) 
       b <- max(x) 
       (x - a)/(b - a) 
  } 

  # centered histone data
  hi=as.data.frame(YNormZ)
  #hi=as.data.frame(histon_data)
  #2^ log fc value
  YNormZ_anti=as.data.frame(sapply(hi, function(x) 2^x))

  #[0-1] range
  mat_hist <- apply(YNormZ_anti, 2, fun) 
  #mat_hist <- YNormZ2

  #k <- identify_optimal_factorization_rank
  k <- 4

  #with nndsvd seed, k=4
  res_hist <- nmf(mat_hist, k, "brunet", nrun=1000, seed = "nndsvd")
  #consensusmap(res_hist)
  #to visually plot the basis and loading matrices
  layout(cbind(1, 2))
  basismap(res_hist, labRow= row.names(YNormZ))
  coefmap(res_hist)

  # to get matrix of basis and loadings 
  w_hist<-basis(res_hist)
  h_hist<-coef(res_hist)

  list(w_hist=w_hist, h_hist=h_hist)
}

hist = generate_nmf_modules(histon_data)

write.table(hist$w_hist, "centered_histone_drug_result_w_basis_4clust.txt", sep="\t")
write.table(hist$h_hist, "centered_histone_drug_result_h_loading_4clust.txt", sep="\t")
