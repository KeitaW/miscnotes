set.seed(1)

N_time <- 24
N0 <- 100
N1 <- 10
Add_y <- 0.3
Add_x <- 7:12
SD <- 0.3

x <- 1:N_time
y0 <- sin(x/N_time*2*pi)
y1 <- y0
y1[Add_x] <- y1[Add_x] + Add_y
dd <- rbind(data.frame(type=0, Y0), data.frame(type=1, Y1))
write.table(d, file='input/data.txt', row.names=F, sep=',', quote=F)

library(rstan)
# rstan_options(auto_write=TRUE)
# options(mc.cores=parallel::detectCores())

# prepare data
d <- read.csv('input/data.txt')
N_time <- 24
X <- 1:24
d0 <- subset(d, type==0)
d1 <- subset(d, type==1)
data <- list(N_time=N_time, N0=nrow(d0), N1=nrow(d1), X=X, Y0=d0[,-1], Y1=d1[,-1])

# model2
stanmodel2 <- stan_model(file='model2.stan')
fit2 <- sampling(stanmodel2, data=data,
                 init=function() { list(mu=colMeans(d0[,-1])) },
                 iter=1500, warmup=500, seed=123
)