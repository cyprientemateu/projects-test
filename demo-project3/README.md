# Host a Dynamic Resume Locally (Flask + Docker + Nginx + Ansible)

This project hosts a dynamic, interactive resume using Flask. You can run it locally first with Docker, and then fully automate setup with Ansible, including Nginx as a reverse proxy.

---
## 🖼 Architecture & Flow Diagram

Overview: This [diagram](https://github.com/cyprientemateu/projects-test/blob/main/demo-project3/flow-diagram.png) shows how the components of the project interact.

```plaintext
          ┌───────────────────────┐
          │      Browser/User     │
          └──────────┬────────────┘
                     │ HTTP Request (port 80)
                     ▼
          ┌───────────────────────┐
          │       Nginx Reverse    │
          │         Proxy         │
          └──────────┬────────────┘
                     │ Forwards request to container
                     ▼
          ┌───────────────────────┐
          │      Docker Container │
          │       (Flask App)     │
          │  port 5000 inside     │
          └──────────┬────────────┘
                     │ Flask handles route
                     ▼
          ┌───────────────────────┐
          │  Flask Application     │
          │  Renders HTML/CSS      │
          │  Returns Response      │
          └──────────┬────────────┘
                     │ Response
                     ▼
          ┌───────────────────────┐
          │      Browser/User     │
          └───────────────────────┘

```

**Explanation of the architecture:**

- Docker: Packages the Flask application and its dependencies into a container for easy deployment.

- Flask App: Serves your dynamic resume content through a web interface.

- Nginx: Acts as a reverse proxy, handling incoming HTTP requests and forwarding them to the Flask app.

- Ansible (for redeployment): Automates redeployment of the containerized application to ensure consistency and ease of updates.

**Explanation of the flow:** 

1. The user sends a request to your Nginx server (HTTP port 80).

3. Nginx acts as a reverse proxy and forwards the request to the Flask app running inside a Docker container (port 5000).

3. Flask handles the route, renders the HTML/CSS templates, and returns the response.

4. Nginx passes the response back to the user’s browser.
---

## Project Structure
```txt
myresume/
│── app.py
│── requirements.txt
│── Dockerfile
│── static/
│   ├── styles.css
│   ├── profile.jpg         # optional
│   └── resume.pdf          # optional PDF resume
│── templates/
│   ├── index.html
│   ├── about.html
│   ├── projects.html
│   └── contact.html
│── terraform/
│   └── main.tf             # optional cloud infra
│── ansible/
    └── playbook.yml
```
---
## Quick Start (One-Command Setup)

This will install Docker, build the app, run the container, install Nginx, and configure the reverse proxy automatically.

### Clone the repo
git clone [repo-url](https://github.com/cyprientemateu/projects-test.git)

```bash
cd demo-project3/myresume
```
Update the **playbook.yml** file with the below block if you don't have Docker already install in your environment.

```yml
---
- name: Run Flask app with Docker and configure Nginx reverse proxy
  hosts: localhost
  connection: local
  become: true

  tasks:
    - name: Ensure Docker is installed
      apt:
        name: docker.io
        state: present
      when: ansible_os_family == "Debian"

    - name: Ensure Docker service is running
      service:
        name: docker
        state: started
        enabled: true

    - name: Build the Flask app image
      docker_image:
        name: resume-app
        source: build
        build:
          path: ../   # adjust if needed

    - name: Run the container
      docker_container:
        name: resume-app-container
        image: resume-app
        state: started
        restart_policy: always
        ports:
          - "5000:5000"

    - name: Install Nginx
      apt:
        name: nginx
        state: present

    - name: Copy Nginx reverse proxy config
      copy:
        dest: /etc/nginx/sites-available/resume
        content: |
          server {
              listen 80;
              server_name localhost;

              location / {
                  proxy_pass http://127.0.0.1:5000;
                  proxy_set_header Host $host;
                  proxy_set_header X-Real-IP $remote_addr;
                  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                  proxy_set_header X-Forwarded-Proto $scheme;
              }
          }

    - name: Enable reverse proxy config
      file:
        src: /etc/nginx/sites-available/resume
        dest: /etc/nginx/sites-enabled/resume
        state: link
        force: true

    - name: Remove default config
      file:
        path: /etc/nginx/sites-enabled/default
        state: absent

    - name: Restart Nginx
      service:
        name: nginx
        state: restarted
```

### Run the Ansible playbook
```bash
ansible-playbook ansible/playbook.yml --ask-become-pass
```

Once complete, open your browser:
```txt
http://localhost
```

✅ The Flask app is now running behind Nginx on port 80.

---

## Step 1: Deploy Locally Using Docker (Manual Option)

1. Build the Docker image:

```bash
docker build -t resume-app .
```

2. Run the Flask app container in the background:

```bash
docker run -d --name resume-app-container -p 5000:5000 resume-app
```

3. Check the app:

```bash
docker logs resume-app-container
```

Open http://localhost:5000 to see the Flask app.

## Step 2: Configure Nginx Reverse Proxy (Optional Manual)

1. Install Nginx:

```bash
sudo apt update
sudo apt install nginx -y
sudo systemctl enable nginx
sudo systemctl start nginx
```

2. Create a reverse proxy configuration (/etc/nginx/sites-available/resume):

```nginx
server {
    listen 80;
    server_name localhost;

    location / {
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

3. Enable the site and restart Nginx:

```bash
sudo ln -s /etc/nginx/sites-available/resume /etc/nginx/sites-enabled/
sudo rm /etc/nginx/sites-enabled/default
sudo nginx -t
sudo systemctl restart nginx
```

Open http://localhost to see the Flask app through Nginx.

## Step 3: Automate Deployment Using Ansible

Instead of manual steps, the Ansible playbook automates everything:

1. Run the playbook:

```bash
ansible-playbook ansible/playbook.yml --ask-become-pass
```

2. Playbook tasks:

- Install Docker

- Build and run the Flask container (includes requirements.txt)

- Install Nginx

- Add and enable reverse proxy configuration

- Remove default site

- Restart Nginx

3. Open http://localhost in the browser. Flask app is served behind Nginx automatically.

## Step 4: Stop or Remove Containers (Optional)

```bash
# Stop the container
docker stop resume-app-container

# Remove the container
docker rm resume-app-container
```
---
### Notes

- Docker serves the Flask app, Nginx proxies traffic from port 80 to 5000.

- You can deploy this to EC2 or other cloud servers by changing localhost to your public IP or domain.

- Optional: Extend Ansible to deploy in production with Docker Compose or WSGI server.
 
- The Quick Start section ensures anyone can get the app running with a single command on a fresh machine.