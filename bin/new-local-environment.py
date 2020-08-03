#!/bin/python3

import os
import yaml

def prompt_list(msg, default_values=[], unique=True, validator=lambda x: True):
    values = [*default_values]
    if unique:
        values = set(values)
    while True:
        input_values = input(f"{msg} [{','.join(values)}]:")
        if not input_values:
            return list(values)
        if validator(input_values):
            if unique:
                values.add(input_values)
            else:
                values.append(input_values)
        else:
            print("Invalid input:" + input_values)

def prompt_option(msg, choises):
    print(msg)
    if len(choises) == 1:
        print("There is only one option so lets choose that for you (1) " + choises[0])
        return 0
    while True:
        for i, choise in enumerate(choises):
            print(f"   [{i + 1}] {choise}")
        try:
            option = int(input("Option: "))
        except:
            print(f"Please specify a number [1-{len(choises)}]")
            continue
        return option


home = os.environ['HOME']
the_dir = os.path.abspath(os.path.dirname(os.path.dirname(__file__))) + '/'
default_volumes = [
    f'{home}/.ssh:/home/dev/.ssh',
    f'{home}/.zsh_history:/home/dev/.zsh_history:rw',
    f'{home}/.history:/home/dev/.history',
    f'{os.path.abspath(os.curdir)}/:/home/dev/workspace/{os.path.basename(os.path.abspath(os.curdir))}'
]

environments = os.listdir(the_dir + 'docker-environments/')
environment = environments[prompt_option('What environment do you want to use in this project?', choises=environments)]
cvolumes = prompt_list("Specify volumes for this environment", default_values=default_volumes, validator=lambda v: v.startswith('/') and len(p.split(':')) >= 2)
cports = prompt_list("Specify ports for this environment", validator=lambda p: len(p.split(':')) == 2)

docker_compose = yaml.load(open(f'{the_dir}docker-environments/{environment}/docker-compose.yaml', 'r'))

for service in docker_compose['services'].values():
    if isinstance(service.get('build'), dict):
        service['build']['context'] = the_dir
    service['volumes'] = service.get('volumes', []) + cvolumes
    service['ports'] = service.get('ports', []) + cports

with open('docker-compose.yaml', 'w') as dcfile:
    yaml.dump(docker_compose, dcfile)