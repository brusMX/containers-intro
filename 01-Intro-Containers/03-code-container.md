
# Exercise 3 – Coding with containers

Checklist
  * Node & npm installed - [Download here](https://nodejs.org/en/) 
  * VSCode - [Download here](https://code.visualstudio.com/) 
  * [On Windows] Use Powershell to execute commands
  * [Optional] Docker extension for VSCode - [Install here](https://marketplace.visualstudio.com/items?itemName=PeterJausovec.vscode-docker) 

In this exercise, we’ll build out a golang backend and nodejs frontend. 

We’ll build and run the golang backend easily using the golang container then we’ll debug an issue in nodejs by attaching our debugger to the running container. 

## Build and Run the Backend
At a terminal navigate to the directory for the backend

```bash
cd [location of labs git here]/Docker-ACS/Labs/Exercise3/backend/
```

Let’s look at our backend code using vscode, run the following

```bash
code .
```

If you’ve written golang before, or even if you haven’t, it should hopefully be easy to tell roughly what the ‘server.go’ file will do. It will respond to requests on ‘/bar’ with “Hello /bar”

Golang has a relatively complex [install and setup procedure](https://golang.org/doc/install) and requires code to be at a certain path to be built. 

To make this easier we’ll use a docker containers the tools to build and run the code. This pattern can be used to simplify setup and build while also providing local “CI” like functionality for complex projects. 

Run the following to launch a container with the golang tooling and mount the current directory into the container.

>In the command below we use $(pwd) to insert the current working directory into the volume mount command. It’s the same as manually doing ‘-v /current/directory/here:/go/src/test/backend’. Plus, make sure not to use Git Bash.

```bash
docker run -ti --rm -v $(pwd):/go/src/test/backend golang
```
> On windows, when in Command Prompt, use the `%cd%` to get your current directory. The bash command should work as expected under powershell. 

Command Prompt:
```bash
docker run -ti --rm -v %cd%:/go/src/test/backend golang
``` 

Now let’s do a build

```bash
cd src/test/backend/
go build .
```


The build tooling will have worked but you’ll notice in the output that there is a bug we have to fix. 

```bash
root@ce58744b24f3:/go/src/backend# go build .
# command-line-arguments
runtime.main_main·f: relocation target main.main not defined
runtime.main_main·f: undefined: "main.main"
```

We’ve got a typo in our golang file. Switch back to VSCode and in ‘server.go’ change the function name ‘shouldbemain’ to ‘main’ and save the file. 

As the directory is mounted into our container we can now simple rerun the build command to see if our fix worked. Let’s rebuild and run the backend:

```bash
go build .
./backend
```

With the server is up and running you should see:

```bash
root@ce58744b24f3:/go/src/backend# go build .
root@ce58744b24f3:/go/src/backend# ./backend
Hooking up hanlders...
Running server...
```

Now that we’ve fixed the bug let’s use the dockerfile*  to build a docker image and use this to run the backend. Use ‘ctrl-c’ and then ‘exit’ to leave golang tools container. Now build the docker file:

> *This file uses the golang container to build our application then copies the binary into a new container, which doesn’t contain all the golang build tools. This keeps the container image nice and small for speedy deployments. 

```bash
docker build . -t gobackend
docker run -d -p 8181:80 gobackend
```

Open a browser and test the service by hitting [http://localhost:8181/bar](http://localhost:8181/bar) you should see ‘hello, /bar”

## Build and Debug the Frontend (Adapted from [Docker-tools lab](https://github.com/docker/labs/blob/master/developer-tools/nodejs-debugging/VSCode-README.md))

Now let’s get the frontend setup, surprise surprise we’ll run this in a container. In the frontend, let’s pretend there a more complex bug which we’ll need to debug through VSCode. 

Open the directory and start VSCode

```bash
cd [location of labs git repo]/Docker-ACS/Labs/Exercise3/frontend/
code .
```

We’ve got a fairly simple nodejs app, you can have a look at ‘app.js’ but don’t worry too much for now. 

Let’s focus on the ‘.vscode’ directory. This has a ‘task.json’ and ‘launch.json’ which will let us build and then debug our node app inside the same container it will use when deployed. This is great to get those hard to find bugs related to environment setup and avoid the “Works here but not when deployed” nightmare. 

Let’s try it. 

1.	CTRL+Shift+B (Windows) or CMD+Shift+B (Mac) to build and start your container
2.	Wait for that to complete
3.	Press F5 to start debugging
4.  Browse the site at [http://localhost:8182](http://localhost:8182)
5.	Open ‘app.js’ and set a breakpoint on Line 5 
6.	Change some of the words in the string on Line 8 and save the file
7.	See how the breakpoint is hit!

### How did that work?

In the dockerfile, as with python earlier, we install our dependencies and copy in our code. 

```bash
FROM node:8.2.1-alpine

WORKDIR /code

RUN npm install -g nodemon@1.11.0

COPY package.json /code/package.json
RUN npm install && npm ls
RUN mv /code/node_modules /node_modules

COPY . /code

CMD ["npm", "start"]
```

We use the ‘nodemon’ tool which will run our node app and restart it each time one of the source files changes. We’ll use the same trick as we in our golang example to mount our current directory so edits in VSCode affect the container. 

By default, our container doesn’t run using nodemon as you wouldn’t want this in production, instead the ‘CMD’ statement uses npm to launch the app normally. We’re going to override this behavior by passing a command when we call ‘docker run’.

To make this easier to use we’ve setup these commands as build tasks in VSCode. If you look at ‘.vscode/tasks.json’ you will see the following: 

```json
{
    "version": "2.0.0",
    "tasks": [
        {
            "taskName": "Build Container",
            "type": "shell",
            "command": "docker build . -t debugimage"
        },
(...)
```

```json
(...)
        {
            "taskName": "Run Container",
            "type": "shell",            
            "command": "docker run --rm -v ${workspaceRoot}:/code -p 8182:8000 -p 9339:9339 --name debuginstance debugimage nodemon --inspect-brk=0.0.0.0:9339",
            "isBackground": true,
            "promptOnClose": true,
            "dependsOn": [
                "Build Container"
            ]
        }
  ]
}}
```

> In the command `${workspaceRoot}` inserts the directory you currently have open in VSCode, `[lab git location]/Docker-ACS/Labs/Exercise3/frontend/`. This replaces `${PWD}` or `%CD%`, which we used earlier in the exercise. You can see the other variables available to you in VSCode task files [here](https://code.visualstudio.com/docs/editor/tasks#_variable-substitution)

This file defines our default build task, so you can press CTRL+Shift+B (Windows) or CMD+Shift+B (Mac) to build and start your container. Try this now and see what happens. 

The first section builds the container from the docker file. 

The second section runs the docker container in the background, the arguments do as follows:
1.	‘-v’ mounts the current directory into the container so code changes in VSCode are available in the container
2.	‘-p’ to exposing the port for the web app and the debugger. 
3.	‘debugcontainer’ specifies the image name to use
4.	‘nodemon –--inspect-brk=9229’  will get executed inside the container when it starts. It starts nodemon and the debugger. 

Now let’s take a look at ‘.vscode/launch.json’ this file defines how VSCode debugs your application. 

```json
   {
        "version": "0.2.0",
        "configurations": [
            {
                "name": "Docker: Attach to Node",
                "type": "node",
                "request": "attach",
                "port": 9339,
                "address": "localhost",
                "localRoot": "${workspaceRoot}",
                "remoteRoot": "/code",
                "restart": true,
                "sourceMaps": false        
           }
        ]
    }
```

Here, VSCode will use node and it should attach to the debugger on port 9339. Also, VSCode will know where the source files are stored in the container with the `remoteRoot` property. This is crucial, as it allows VSCode to map break points from the editor to the code running in the container. 

