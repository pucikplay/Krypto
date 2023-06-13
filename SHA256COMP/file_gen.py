import string
import random

def gen_file(letter, file):
    with open(file, 'w') as f:
        for _ in range(1000):
            f.write(letter * 100 + '\n')
        f.close()


if __name__ == "__main__":
    letters = string.ascii_lowercase
    count = 1000
    for i in range(count):
        filename = "files/in{}.txt".format(i)
        letter = random.choice(letters)
        gen_file(letter, filename)

    with open("files.txt", 'w') as f:
        for i in range(count):
            f.write("files/in{}.txt\n".format(i))
        f.close()