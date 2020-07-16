# SQL-Queries
A slew of SQL queries, and Python notebooks to explore the Learn Bb Database.

# Setup
This repository has two important things that are needed to get started:
1. A Dockerfile
2. Template files.

## Before you begin
Here are the software you need before you will be able to clone and use this repository:
1. [Docker](https://docs.docker.com/get-docker/)
2. [VS Code](https://code.visualstudio.com/download)
3. [VS Code Docker Extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker)
4. [VS Code Remote Dev Pack](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack)
I used these for the Demonstration at Devcon. 

## Dockerfile
The dockerfile does have one major requirement that you need to provide, and that's the oracle instant client. If you don't need an Oracle connection, great! I do. Please edit the Dockerfile to remove all those parts. Otherwise, you can grab the 19_6 instant client here: [Oracle Instant Clinet](https://www.oracle.com/database/technologies/instant-client/linux-x86-64-downloads.html).  In this case, you need the linux instant client, because that's what your docker container will run.  Rename this 'instant_client_19_6.zip' and place it in the top level folder with the rest of the code. 

## Env files / Oracle Config files
I've included template files for you to get started.  If you don't need oracle, great! Ignore everything in network/admin.  If you do - then you need to enter in values for your institution, and save that as a file that ends in '.ora'.  In the .env.template file - there are places for credentials for a typical database, a snowflake instance, and microsoft graph credentials.  Make sure to enter whichever you need. (it may just be snowflake).

I hope this helps someone else get started as an SQL explorer.  Or helps an SQL master share their data more broadly with colleagues. Good luck!
