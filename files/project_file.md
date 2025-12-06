# Stop the container
docker stop resume-app-container

# Remove the container
docker rm resume-app-container
Host a Dynamic Resume (Using Flask or Node.js)
If your resume is interactive (e.g., a web app with Flask or Node.js), you'll need an EC2 instance with a backend server.

### Steps:
I. Launch an EC2 instance and install Python/Flask or Node.js.

II. Deploy your web app (Flask, Express, etc.).

III. Configure Nginx as a reverse proxy.

IV. Use a domain (optional, via Route 53).

## Option 1: Using Flask (Python)
1. Launch an EC2 Instance
- Select Amazon Linux 2 or Ubuntu.
- Open required ports: 22 (SSH), 80 (HTTP), 443 (HTTPS).

2. Connect to the Instance
```sh
ssh -i your-key.pem ec2-user@your-ec2-public-ip
```
3. Update and Add Required Repositories (Dependencies)
```sh
sudo apt update
sudo apt upgrade -y
sudo apt install software-properties-common -y
```
4. Add Universe Repository (if missing)
```sh
sudo add-apt-repository universe
sudo apt update
```
5. Install Python3 and pip
```sh
sudo apt install python3 python3-pip -y
```
6. Verify Installation
```bash
python3 --version
pip3 --version
```
You should see something like:
```csharp
Python 3.x.x
pip 20.x.x from ...
```
7. Install Flask

✅ Use a Virtual Environment
Step 1: Install python3-venv
```bash
sudo apt install python3-venv -y
```
Step 2: Create a Virtual Environment
```bash
python3 -m venv myenv
```
Step 3: Activate the Virtual Environment
```bash
source myenv/bin/activate
```
Your prompt will now look like this:
```bash
(myenv) ubuntu@ip-172-31-26-7:~$
```
Step 4: Install Flask inside the Virtual Environment
```bash
pip install flask
```
Step 5: Run Your Flask App
Now you can run your Flask app normally:

```bash
python app.py
```
✅ Optional: Deactivate Environment
When you're done working:

```bash
deactivate
```
### Project Structure
```ccp
myresume/
│── static/
│   ├── styles.css
│   ├── profile.jpg
│── templates/
│   ├── index.html
│   ├── about.html
│   ├── projects.html
│   ├── contact.html
│── app.py
```
Create **app.py**
```python
from flask import Flask, render_template

app = Flask(__name__)

@app.route("/")
def home():
    return render_template("index.html")

@app.route("/about")
def about():
    return render_template("about.html")

@app.route("/projects")
def projects():
    return render_template("projects.html")

@app.route("/contact")
def contact():
    return render_template("contact.html")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
```
Create **templates/index.html**
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Resume</title>
    <link rel="stylesheet" href="{{ url_for('static', filename='styles.css') }}">
</head>
<body>
    <header>
        <h1>Welcome to My Resume</h1>
        <nav>
            <a href="/">Home</a>
            <a href="/about">About</a>
            <a href="/projects">Projects</a>
            <a href="/contact">Contact</a>
        </nav>
    </header>

    <section>
        <h2>Hello, I'm [Your Name]</h2>
        <p>I'm a DevOps/Cloud Engineer specializing in cloud automation, CI/CD, and security.</p>
    </section>
</body>
</html>
```
Create **templates/about.html**
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Me</title>
    <link rel="stylesheet" href="{{ url_for('static', filename='styles.css') }}">
</head>
<body>
    <header>
        <h1>About Me</h1>
        <nav>
            <a href="/">Home</a>
            <a href="/about">About</a>
            <a href="/projects">Projects</a>
            <a href="/contact">Contact</a>
        </nav>
    </header>

    <section>
        <h2>Who Am I?</h2>
        <p>I am a DevSecOps Engineer with experience in AWS, Kubernetes, CI/CD, and security automation.</p>
    </section>
</body>
</html>
```

Create **templates/projects.html**
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Projects</title>
    <link rel="stylesheet" href="{{ url_for('static', filename='styles.css') }}">
</head>
<body>
    <header>
        <h1>Projects</h1>
        <nav>
            <a href="/">Home</a>
            <a href="/about">About</a>
            <a href="/projects">Projects</a>
            <a href="/contact">Contact</a>
        </nav>
    </header>

    <section>
        <h2>Highlighted Projects</h2>
        <ul>
            <li><b>Cloud Infrastructure Automation</b> - Built scalable infrastructure using Terraform.</li>
            <li><b>CI/CD Pipeline</b> - Reduced deployment time by 75% using Jenkins & Docker.</li>
            <li><b>Security Automation</b> - Implemented security policies using DevSecOps best practices.</li>
        </ul>
    </section>
</body>
</html>
```

Create **templates/contact.html**
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Me</title>
    <link rel="stylesheet" href="{{ url_for('static', filename='styles.css') }}">
</head>
<body>
    <header>
        <h1>Contact Me</h1>
        <nav>
            <a href="/">Home</a>
            <a href="/about">About</a>
            <a href="/projects">Projects</a>
            <a href="/contact">Contact</a>
        </nav>
    </header>

    <section>
        <h2>Get in Touch</h2>
        <p>Email: yourname@example.com</p>
        <p>LinkedIn: linkedin.com/in/yourprofile</p>
        <p>GitHub: github.com/yourprofile</p>
    </section>
</body>
</html>
```

Create **static/styles.css**
```css
body {
    font-family: Arial, sans-serif;
    text-align: center;
    margin: 0;
    padding: 0;
    background-color: #f4f4f4;
}

header {
    background-color: #333;
    color: white;
    padding: 20px;
}

nav a {
    color: white;
    text-decoration: none;
    margin: 0 15px;
}

section {
    margin: 50px;
    padding: 20px;
    background: white;
    border-radius: 10px;
    box-shadow: 0px 0px 10px gray;
}
```
Run the Flask App
- method 1:
```sh
python3 app.py
```
- Open http://your-ec2-public-ip:5000 to see your resume.

- method 2:
1. Using nohup (No Hang Up)
This method will keep your Flask app running even if you log out of the SSH session.

1. - Run your Flask app with nohup:

```bash
nohup python3 app.py &
```
- The & runs the app in the background.

- nohup ensures the app keeps running even after you log out.

2. - Check if it’s running:

```bash
ps aux | grep app.py
```
You should see the Flask app running in the background.

3. - Log Output: By default, nohup will output logs to a file called nohup.out. You can check it:

```bash
cat nohup.out
```

## Set Up Nginx Reverse Proxy
```sh
sudo apt install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx
```

Edit Nginx config:
```sh
sudo vim /etc/nginx/nginx.conf
```
Modify **server {}** block:
```nignx
server {
    listen 80;
    location / {
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

Restart Nginx:
```sh
sudo systemctl restart nginx
```
Now, access http://your-ec2-public-ip/ without specifying port 5000.

# Or create one:
✅ Step-by-Step: Proper Nginx Server Block for Flask App
1️⃣ Un-comment or Create a Server Block File
Let’s say you're using this path:
/etc/nginx/sites-available/resume

```bash
sudo vim /etc/nginx/sites-available/resume
```

Example config to add to the file:

```nginx
server {
    listen 80;
    server_name YOUR_PUBLIC_IP;  #server_name 54.123.45.67; or server_name myresume.com;

    location / {
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```
Replace **YOUR_PUBLIC_IP** with your actual EC2 public IP or domain (if you have one).

2️⃣ Enable the Site or Server Block
Now, create a symbolic link to this file from /etc/nginx/sites-enabled/ to enable it.
Link it from **sites-available** to **sites-enabled**:

```bash
sudo ln -s /etc/nginx/sites-available/resume /etc/nginx/sites-enabled/
```
3️⃣ Test Nginx Config
```bash
sudo nginx -t
```
You should see:

```bash
nginx: configuration file /etc/nginx/nginx.conf test is successful
```
4️⃣ Restart Nginx
```bash
sudo systemctl restart nginx
```
🔥 Now Try This in Your Browser:
- Make sure that your Flask app is still running on http://127.0.0.1:5000 on the EC2 instance.
- Open your browser and visit:
```cpp
Copy
Edit
http://<your-ec2-public-ip>
```
If everything is wired right, Nginx will proxy traffic to your Flask app running on port 5000.

# Troubleshooting steps
If you're seeing the default Nginx page (often a "Welcome to Nginx" page) instead of your Flask app, it usually means Nginx is serving its default configuration instead of the one you created for your Flask app.

Here’s how to fix that:

✅ 1. Check if the Default Server Block Is Enabled
Nginx may still be using the default configuration, which is usually stored in /etc/nginx/sites-enabled/default.

Check if the default server block is enabled:

```bash
ls -l /etc/nginx/sites-enabled/
```
If you see a symbolic link for default, it means Nginx is still using the default configuration.
```bash
lrwxrwxrwx 1 root root 34 Apr  4 02:38 default -> /etc/nginx/sites-available/default
lrwxrwxrwx 1 root root 33 Apr  4 02:57 resume -> /etc/nginx/sites-available/resume
```
Disable the default configuration by removing the symbolic link:

```bash
sudo rm /etc/nginx/sites-enabled/default
```
✅ 2. Ensure Your Custom Server Block Is Enabled
Make sure your server block for your Flask app (e.g., /etc/nginx/sites-available/resume) is properly linked to the sites-enabled directory.

```bash
sudo ln -s /etc/nginx/sites-available/resume /etc/nginx/sites-enabled/
```
You can confirm it’s linked by running:

```bash
ls -l /etc/nginx/sites-enabled/
```
It should show a link to the resume configuration file.
```bash
lrwxrwxrwx 1 root root 33 Apr  4 02:57 resume -> /etc/nginx/sites-available/resume
```

✅ 3. Test the Nginx Configuration
Before restarting Nginx, test the configuration for errors:

```bash
sudo nginx -t
```
If everything is okay, you'll see:

```bash
nginx: configuration file /etc/nginx/nginx.conf test is successful
```
✅ 4. Restart Nginx
After confirming that the default configuration is disabled and your Flask app's server block is enabled, restart Nginx:

```bash
sudo systemctl restart nginx
```
✅ 5. Check the Firewall (Optional)
If your app still doesn't show, make sure port 80 is open in your security group and firewall settings.

✅ 6. Clear Browser Cache
Sometimes, the browser caches the old "Welcome to Nginx" page. Try clearing the cache or access the site using Incognito mode.

Final Test:
Visit your EC2 public IP in the browser again:

```cpp
http://<your-ec2-public-ip>
```
You should now see your Flask app!

These steps allow you to update Nginx settings without affecting your Flask app. Nginx can be restarted while your app is running, as the Flask app is managed independently.