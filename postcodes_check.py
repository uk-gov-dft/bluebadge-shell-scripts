import sys
import json

def main():
  csv_file = sys.argv[1]
  items = []
  
  with open(csv_file, 'r+', encoding='utf-8-sig') as csv:
    codes = []
    for line in csv:
        codes.append(line.strip())
        if len(codes) == 100:
          items.append({"postcodes": codes})
          codes = []
    if len(codes) > 0:
        items.append({"postcodes": codes})

  for index, item in enumerate(items):
    print("curl -s -H 'Content-Type: application/json' -d'{}' https://api.postcodes.io/postcodes | jq '.' > {}.json".format(json.dumps(item), index+1))


if __name__ == '__main__':
  main()
