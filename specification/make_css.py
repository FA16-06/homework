"""

"""

TOP_LEVEL = '''
ul {{
  list-style-type: none;
}}
'''

FIRST_LEVEL = '''
body > ul > li:nth-child({i})::before {{
  font-weight: bold;
  content: "{i}. ";
}}
'''

SECOND_LEVEL = '''
body > ul > li:nth-child({i}) > ul > li:nth-child({j})::before {{
  font-weight: bold;
  content: "{i}.{j}. ";
}}
'''

THIRD_LEVEL = '''
body > ul > li:nth-child({i}) > ul > li:nth-child({j}) > ul > li:nth-child({k})::before {{
  font-weight: bold;
  content: "{i}.{j}.{k}. ";
}}
'''

def main(max_depth):
    print(TOP_LEVEL.format())
    for i in range(max_depth):
        print(FIRST_LEVEL.format(i=i))
        for j in range(max_depth):
            print(SECOND_LEVEL.format(i=i, j=j))

            for k in range(max_depth):
                print(THIRD_LEVEL.format(i=i, j=j, k=k))

if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument('--max-depth', type=int, default=20)
    args = parser.parse_args()

    main(**vars(args))
