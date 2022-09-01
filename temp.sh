#! /bin/bash
docker buildx build . -t KarlaMonterrubioG/competing_risks:latest --platform linux/arm64,linux/amd64 --cpuset-cpus 0-9
#docker buildx build . -t KarlaMonterrubioG/Competing_risks:latest --platform linux/arm64,linux/amd64 --cpuset-cpus 0-9 --push github.com/KarlaMonterrubioG/Competing_risks
docker run -v output:/Output KarlaMonterrubioG/Competing_risks