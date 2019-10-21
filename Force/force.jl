function simulate()
    N = 500
    p = 0.1
    g = 1.5
    alpha = 1.0
    nsecs = 1440
    dt = 0.1
    learn_every = 2#2.0
    pi = 3.1415
    scale = 1.0/sqrt(p*N)

    M = zeros(Float64, N, N);

    for i in 1:N
        for j in 1:N
            if rand() < p           
                M[i, j] = randn() * g * scale
            end
        end
    end

    nRec2Out = N
    wo = zeros(Float64, nRec2Out)
    dw = zeros(Float64, nRec2Out)
    wf = 2.0*(rand(N)-0.5);

    simtime = 0:dt:nsecs
    simtime_len = length(simtime)

    amp = 1.3
    freq = 1.0/60
    fts = (amp/1.0).*sin(1.0*pi*freq*simtime) +(amp/2.0).*sin(2.0*pi*freq*simtime) +(amp/6.0).*sin(3.0*pi*freq*simtime) + (amp/3.0).*sin(4.0*pi*freq*simtime)
    fts = fts /1.5;


    x0 = 0.5*randn(N)
    z0 = 0.5*randn(1)

    x = x0
    r = tanh(x)
    z = z0

    P = (1.0/alpha).* eye(Float64, nRec2Out);

    zlist = zeros(Float64, length(simtime))
    for (i, (t, ft)) in enumerate(zip(simtime, fts))
        x = (1.0 - dt) .* x + M * r .* dt + wf .* (z * dt)
        r = tanh(x)
        z = wo' * r
        if i % learn_every == 0
            k = P * r
            rPr = r' * k
            c = 1.0 ./ (1.0 + rPr)
            P = P - c .* (k * k')
            e = z - ft
            dw = -(c' * e) .* k
            wo = wo + dw
        end
        zlist[i] = z[1]
    end
    return zlist
end
simulate()
#using ProfileView
#Profile.clear()
#@profile simulate()
#ProfileView.view()

