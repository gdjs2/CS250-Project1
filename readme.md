### Project 1 - CS250

There are two most important parts in this tool.

* Dockerfile
* ./script/hybrid_fuzzing

#### Usage

```shell
git clone https://github.com/gdjs2/CS250-Project1.git
docker build -t cs250-project1-gdjs2 .
docker run -v `pwd`:/shared -it --rm cs250-project1-gdjs2 bash
```

After you enter the bash, you are in the directory /workdir, and you have mount /shared.

Run the commands in the docker
```shell
python3 /shared/script/hybrid_fuzzing.py [target_name]
```
where target_name is the file name you want to test which is in /shared directory.

Then you can find seed & afl status folder under /workdir/afl_out. 