data {
  int N_time;
  int N0;
  int N1;
  int X[N_time];
  vector[N_time] Y0[N0];
  vector[N_time] Y1[N1];
}

parameters {
  vector[N_time] mu;
  real di0;
  vector<lower=-pi()/2, upper=pi()/2>[N_time-1] di_unif;
  real<lower=0> s_mu;
  real<lower=0> s_di;
  real<lower=0> s_Y;
}

transformed parameters {
  vector[N_time] di;
  vector[N_time] y1_mean;
  di[1] <- di0;
  for (t in 2:N_time)
    di[t] <- di[t-1] + s_di*tan(di_unif[t-1]);
  y1_mean <- mu + di;
}

model {
  for (t in 3:N_time)
    mu[t] ~ normal(2*mu[t-1] - mu[t-2], s_mu);
  for (n in 1:N0)
    Y0[n] ~ normal(mu, s_Y);
  for (n in 1:N1)
    Y1[n] ~ normal(y1_mean, s_Y);
}
