import matplotlib.pyplot as plt
import csv

if __name__ == "__main__":
    CUDA = {}
    CPU = {}

    with open('out.csv') as csvfile:
        reader = csv.reader(csvfile, delimiter=',')
        for row in reader:
            CUDA[int(row[0])] = float(row[1])
            CPU[int(row[0])] = float(row[2])

    plt.plot(CUDA.keys(), CUDA.values(), label='CUDA')
    plt.plot(CPU.keys(), CPU.values(), label='CPU')
    plt.xscale('log')
    plt.yscale('log')
    plt.xlabel("# of files to hash")
    plt.ylabel("avg time of computation")
    plt.legend()
    plt.savefig("graph.png", dpi=300)