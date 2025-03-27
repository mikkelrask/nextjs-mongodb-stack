# NextJS/MongoDB starter stack
You developed your NextJS webapp locally, and now you want to containerize it with Docker on your server/VPS. 

This will get your webapp up and running with its own MongoDB database _blazingly fast_ and very limited setup. ⚡

## Getting Started

1. Clone the repo and cd into it  

```bash
git clone https://github.com/mikkelrask/nextjs-mongodb-stack.git 
cd nextjs-mongodb-stack
```
  
2. Run the included [deployer]("../nextjs-mongodb-stack-godeployer") for a prompt based setup
```bash
./deployer
🚀 DPLOY - BUILD YOUR WEBSITE

Fill the needed data to deploy your webapp - Enter keeps the suggested default

? NextJS webapp repository URL: https://github.com/SiddharthaMaity/nextjs-15-starter-core.git
? Is the repository private? No
? Do you want to specify a port for NextJS?  3001
? Do you want to import a database dump? Yes
? Database dump path:  ~/Downloads/production/production
📁 Copying the database dump to the dump directory...
? MongoDB Database name? production
? MongoDB Username:  admin
....
....
```

### Alternate step 2: Do it manual
2. Copy/move `env-example` to `.env`, and make changes to your needs.   
Also add any potentially other needed environment variables for your project in this step.
```bash
cat env-example > .env
nano .env
```

```
NEXTJS_PORT=3000 # Defaults to port 3000 - can be changed if needed 

MONGO_USER=your-username # Your desired database user
MONGO_PASS=5tr0n9p455w0rd # And the password you want to use
MONGO_DB_NAME=database # can be left or changed per your liking
MONGO_PORT=27017 # Defaults to 27017 - can be changed if needed 

REPO_URL=https://github.com/SiddharthaMaity/nextjs-15-starter-core.git # The git URL for your nextjs repo
GIT_USER= # Fill out GIT_USER and GIT_PASS if you use a private repo
GIT_PASS=
... 
YOUR-OTHER-SECRETS=SUPER_SECRET
...etc
```

3. Copy your mongodb dump  
If you have a MongoDB dump you need to seed your database with, copy it to the `./mongo-dump` directory
```bash
cp /path/to/json-dumps mongo-dump/
```
The dump is automatically being restored when the containers start, and the webapp will not start to build until MongoDB is ready and potentially restored.  
 
4. Build and up the stack  
Use the `--no-cache` and `--force-recreate` flags to always get the latest images layers and data from the db.  
```bash
docker compose build --no-cache
docker compose up -d --force-recreate
```
**This will**
- Pull you Github repository from Github/Gitlab
- Install all node dependencies with `pnpm`[^](https://pnpm.io/)
- Build a custom Docker image based on the [current node/alpine image](https://hub.docker.com/_/node)
- Spin up the containers `nextjs-mongodb-stack-frontend-1` and `nextjs-mongodb-stack-mongodb-1`
- Make sure the database has all needed data, and makes it available on the port specified in the `.env` file (default: `27017`)
- Build the webapp 
- Start the next server with `node` (default port: `3000`)

The site is now live on `http://127.0.0.1:3000`/`http://localhost:3000` and the database on port `27017`  
Confirm the stack is running with `docker ps` - the container name depends on your folder naming (defaults to "nextjs-mongodb-stack")

## Rebuild
After making changes to the repo/database rebuild and restart the stack.  

You can do this with re-running the includeded `deployer` or with: 
```bash
docker compose down --volumes
docker compose up --build --force-recreate -d
```

Alternately set up the supplied [yaml workflow file](./workflows/rebuild-on-push.yml) as a [Github Action](https://docs.github.com/en/actions) in the repository for your NextJS project.  
This route requires you to create a SSH key on your server and supply that as well as your server IP as [repository secrets](https://docs.github.com/en/actions/security-for-github-actions/security-guides/about-secrets) in the repo as well.
