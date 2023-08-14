#!/bin/bash

# Check if a directory name is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <directory_name>"
    exit 1
fi

dir_name=$1

if [ ! -d "$dir_name" ]; then
    echo "Creating directory $dir_name..."
    mkdir "$dir_name"
else
    if [ "$(find "$dir_name" -maxdepth 1 -type f | wc -l)" -gt 0 ]; then
        echo "Error: There are files in $dir_name."
        exit 1
    fi
fi

cd "$dir_name"

echo "Initializing npm project..."
npm init -y

echo "Installing necessary npm packages..."
npm i typescript express
npm i -D nodemon @types/express @types/node

echo "Initializing TypeScript..."
npx tsc --init 

# Remove JSON comments using jq
sed -i -r '/^[ \t]*\//d; /^[[:space:]]*$/d; s/\/\*(.*?)\*\///g; s/[[:blank:]]+$//' tsconfig.json
# Add necessary dependencies
jq '.compilerOptions += {"rootDir": "./src", "outDir": "./dist"}' tsconfig.json > tsconfig.tmp && mv tsconfig.tmp tsconfig.json
jq '.scripts += { "build": "npx tsc", "start": "npx nodemon ./dist/server.js" }' package.json > tmp.json && mv tmp.json package.json

echo "Creating src and dist directories..."
mkdir src/
mkdir dist/

echo "Writing server code to src/server.ts..."
cat <<-EOF > src/server.ts
import express, {Express, Request, Response} from 'express';

const app: Express = express();
const port = 8000;

app.get('/', (req: Request, res: Response) => {
  res.send('This is an Express + Typescript server');
});

app.listen(port, () => {
  console.log(\`[server]: server is running at http://localhost:\${port}\`);
});
EOF
npm run build
echo "Setup complete!"
echo "Use \`npm run build\` to build the project and \`npm run start\` to start the server."
