import re

conditions = []

masks = {'a1': [0,0,0],
         'd1': [0,0,0],
         'c1': [0,0,0],
         'b1': [0,0,0],
         'a2': [0,0,0],
         'd2': [0,0,0],
         'c2': [0,0,0],
         'b2': [0,0,0],
         'a3': [0,0,0],
         'd3': [0,0,0],
         'c3': [0,0,0],
         'b3': [0,0,0],
         'a4': [0,0,0],
         'd4': [0,0,0],
         'c4': [0,0,0],
         'b4': [0,0,0]}

if __name__ == "__main__":
    with open("Labo/L1/bits.txt", 'r') as f:
        for line in f.readlines():
            for x in re.split(r', |\n|,\n', line):
                if (len(x) > 0):
                    conditions.append(x)
    f.close()

for c in conditions:
    sides = c.split(" = ")
    place = sides[0].split(",")
    if (sides[1] == '0'):
        masks[place[0]][0] += 2**(int(place[1])-1)
    elif (sides[1] == '1'):
        masks[place[0]][1] += 2**(int(place[1])-1)
    else:
        masks[place[0]][2] += 2**(int(place[1])-1)

for set in masks:
    print("#define {}_0 {}\n#define {}_1 {}\n#define {}_P {}".format(set.upper(),
                                  format(masks[set][0],"#010x"),
                                  set.upper(),
                                  format(masks[set][1],"#010x"),
                                  set.upper(),
                                  format(masks[set][2],"#010x")))