# Initialize-typescript-node-server
Bash script to initialize an express with typescript project with nodemon and ES2016 enabled by default.

Currently only supports the linux command line (terminal)

# Dependencies
jq must be installed to run the script. Install via

```
$ sudo apt install jq
```

### Installation
Download bash script or clone repository

type `chmod +x` name of bash script`` into the terminal
run file with bash using the directory path as a parameter.

### Usage
Run `npm run build` to transpile typescript code in the src folder into the dist folder
run `npm start` to start nodemon server


nodemon only runs off of the transpiled javascript code. The code must continuosly be rebuilt for the server to update.
