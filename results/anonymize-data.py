import random
import json
import sys
from os import path, listdir

filename = sys.argv[1]

new_filename, ext = path.splitext(filename)
new_filename += "_anonymized"
new_filename += ext

with open(filename, 'r') as f:
    filestring = f.read()
    file_data = json.loads(filestring)

generated_hitIds = []
generated_workerIds = []
generated_assignmentIds = []


# Check if there is already an ID_map and read if there is
id_map_filename = "anonymized_id_map.json"
id_map_file = "results/" + id_map_filename
id_map_exists = id_map_filename in listdir('results/')
if id_map_exists:
    with open(id_map_file, 'r') as f:
        filestring = f.read()
        id_map = json.loads(filestring)
else:
    id_map = {'workerId': {}, 'hitId': {}, 'assignmentId': {}}

def generate_random_id(prefix, existing):
    while True:
        new_id = prefix + str(random.randint(10000000, 99999999))
        if new_id not in existing:
            existing.append(new_id)
            return new_id
        else:
            continue

for part in file_data["values"]:
    # 0 = uniqueId
    # 1 = assignmentId
    # 2 = workerId
    # 3 = hitId
    # 4 = IP address
    old_ass_id = part[1]
    old_worker_id = part[2]
    old_hit_id = part[3]
    new_ass_id = generate_random_id('a',generated_assignmentIds)
    new_worker_id = generate_random_id('w', generated_workerIds)
    new_hit_id = generate_random_id('h', generated_hitIds)

    # Erase ip address, browser
    part[4] = "<redacted>"
    part[5] = "<redacted>"

    part[0] = part[0].replace(old_worker_id, new_worker_id).replace(old_ass_id, new_ass_id)

    # Save new mapping to json file
    id_map["assignmentId"][part[1]] = new_ass_id
    id_map["workerId"][part[2]] = new_worker_id
    id_map["hitId"][part[3]] = new_hit_id


    part[1] = new_ass_id
    part[2] = new_worker_id
    part[3] = new_hit_id


    try:
        # replace all occurrences of IDs in datastring
        part[17] = part[17].replace(old_worker_id, new_worker_id).replace(old_hit_id, new_hit_id).replace(old_ass_id, new_ass_id)
    except:
        continue

    print(f"Done with worker {old_worker_id}")


with open(new_filename, 'w') as f:
    json.dump(file_data, f)

print(f"Wrote to {new_filename}")

with open(id_map_file, 'w') as f:
    json.dump(id_map, f)

print(f"Wrote mapping to {id_map_file}")