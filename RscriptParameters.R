  args <- commandArgs(TRUE); 
  argmat <- sapply(strsplit(args, "="), identity) 
  
  for (i in seq.int(length=ncol(argmat))) { 
      assign(argmat[1, i], argmat[2, i]) 
  } 
account <- arg1
