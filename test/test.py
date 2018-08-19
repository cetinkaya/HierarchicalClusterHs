import numpy as np
import numpy.random as ra
import matplotlib.pyplot as pl
import os


def plot_clusters():
    data = np.loadtxt("./TestWithClusters.txt")
    xs = data[:, 0]
    ys = data[:, 1]
    cs = data[:, 2]
    pl.rc('ps', usedistiller='xpdf')
    pl.rc('text', usetex = True)
    pl.rc('font', size=14)
    pl.rc('text.latex', preamble="\\usepackage{amsmath}, \\usepackage{amssymb}")
    pl.rcParams['mathtext.fontset'] = 'custom'
    fig = pl.figure(figsize=(5.65, 5.2))
    pl.scatter(xs, ys, c=cs)
    pl.xlabel(r"$x_1$")
    pl.ylabel(r"$x_2$")
    pl.savefig("TestResult.png", bbox_inches='tight')


def write_data(n):
    data = np.zeros((3*n, 2))
    for i in range(n):
        theta = (i / n) * 2 * np.pi
        x = np.cos(theta)
        y = np.sin(theta)
        ex = ra.uniform(-0.1, 0.1)
        ey = ra.uniform(-0.1, 0.1)
        data[i, 0] = x + ex
        data[i, 1] = y + ey
    for i in range(n):
        theta = (i / n) * 2 * np.pi
        x = 0.5*np.cos(theta)
        y = 0.5*np.sin(theta)
        ex = ra.uniform(-0.1, 0.1)
        ey = ra.uniform(-0.1, 0.1)
        data[n+i, 0] = x + ex
        data[n+i, 1] = y + ey

    for i in range(n):
        x = 1.5
        y = i * 0.02
        ex = ra.uniform(-0.1, 0.1)
        ey = ra.uniform(-0.1, 0.1)
        data[2*n+i, 0] = x + ex
        data[2*n+i, 1] = y + ey

    np.savetxt("./Test.txt", data, fmt="%.7f", newline='\n',delimiter=' ')

write_data(100)
os.system("HierarchicalClusterHs Test.txt TestWithClusters.txt 3")
plot_clusters()
