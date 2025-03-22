# NextJS/MongoDB starter stack
You developed your NextJS webapp locally, and now you want to containerize it with Docker on your server/VPS. 

This will get your webapp up and running with its own MongoDB database _blazingly fast_ and very limited setup. ⚡

## Getting Started

1. Clone the repo and cd into it  

```bash
git clone https://github.com/mikkelrask/nextjs-mongodb-stack.git 
cd nextjs-mongodb-stack
```
  
2. Copy/move `env-example` to `.env` with `cp env-example .env`, and fill out the details.   
Add any potentially other environment variables your project needs in this step too.
```env
MONGO_USER=your-username # Your desired database user
MONGO_PASS=5tr0n9p455w0rd # And the password you want to use
MONGO_DB_NAME=database # can be left or changed per your liking
MONGO_DUMP_FILENAME=your-dump.json # The filename for your existing mongodb json dump file
REPO_URL=https://github.com/SiddharthaMaity/nextjs-15-starter-core.git # The git URL for your nextjs repo
... 
YOUR-SECRET-VARIABLE=SECRET_VALUE
...etc
```

3. Copy your mongodb dump  
If you have a MongoDB dump you need to seed your database with, copy it to the `./mongo-dump` directory
```bash
cp /path/to/json-dump-file ./mongo-dump/
```
The dump is automatically being restored when the containers start, and the webapp is waiting to build until MongoDB is ready and restored.  
All MongoDB data is stored in the `./data` directory.
 
4. Build and up the stack  
Use the `--no-cache` and `--force-recreate` flags to always get the latest images layers and data from the db.  
```bash
docker compose build --no-cache
docker compose up -d --force-recreate
```
**This will**
- Spin up the containers
- Pull your repo
- Install node dependencies
- Make sure MongoDB has data (if it needs to) and makes it available on port `27017`
- Build the webapp
- Start the next server on port `3000`

The site is now live on `http://127.0.0.1:3000`/`http://localhost:3000` and the database on port `27017`  
Confirm the stack is running with `docker ps` - the container name depends on your folder naming (defaults to "nextjs-mongodb-stack")

## Rebuild
After making changes to the repo/database rebuild and restart the stack.  
```bash
docker compose down
docker compose up --build --force-recreate -d
```

Alternately set up the supplied [yaml workflow file](./workflows/rebuild-on-push.yml) as a [Github Action](https://docs.github.com/en/actions) in the repository for your NextJS project.  
This route requires you to create a SSH key on your server and supply that as well as your server IP as [repository secrets](https://docs.github.com/en/actions/security-for-github-actions/security-guides/about-secrets) in the repo as well.
