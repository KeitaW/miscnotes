
import numpy as np
from scipy.sparse import rand
def simulate():
    N = 500
    p = 0.1
    g = 1.5
    alpha = 1.0
    nsecs = 1440
    dt = 0.1
    learn_every = 2#2.0
    pi = 3.1415

    scale = 1.0/np.sqrt(p*N)
    """
    M = rand(N,N,density = p)*g*scale
    M=M.todense()
    M = np.array(M)
    """
    M =np.zeros((N,N))
    for i in range(N):
        for j in range(N):
            if np.random.rand()<p:
                M[i,j] = np.random.randn()*g*scale
    nRec2Out = N
    wo = np.zeros(nRec2Out)
    dw = np.zeros(nRec2Out)
    wf = 2.0*(np.random.rand(N)-0.5)

    simtime = np.arange(0,nsecs,dt)
    simtime_len = len(simtime)

    amp = 1.3
    freq = 1.0/60
    ft = (amp/1.0)*np.sin(1.0*pi*freq*simtime)\
        +(amp/2.0)*np.sin(2.0*pi*freq*simtime)\
        +(amp/6.0)*np.sin(3.0*pi*freq*simtime)\
        +(amp/3.0)*np.sin(4.0*pi*freq*simtime)\

    ft=ft/1.5


    x0 = 0.5*np.random.randn(N)
    z0 = 0.5*np.random.randn()

    x = x0
    r = np.tanh(x)
    z = z0


    P = (1.0/alpha)*np.eye(nRec2Out)

    zlist=[]
    for i in range(simtime_len):#simtime_len):
        x = (1.0 - dt)*x + np.dot(M,r)*dt + wf*z*dt
        r = np.tanh(x)
        z = np.dot(wo,r)
        
        
        if (i+1)%learn_every == 0:
            k = np.dot(P,r)
            
            rPr = np.dot(r,k)
            c = 1.0/(1.0 + rPr)
            P = P - c*np.dot(k[:,np.newaxis],k[np.newaxis,:])
            e = z-ft[i]
        
            dw = -(c*e)*k
            wo = wo + dw
        zlist.append(z)

simulate()
