# University Timetable Mini Project

This project is a Dockerized Flask web application that allows users to view university timetables based on their academic level. It uses **PostgreSQL** as the database backend and serves a responsive interface for users to select levels and view related timetable information.

---

## Project Structure

- **`init.sql`**: SQL script to initialize the database and insert sample timetable data.
- **`templates/`**: Contains HTML templates for the web interface.
  - `index.html`: Main page for level selection.
  - `timetable.html`: Displays the timetable for the selected level.
- **`app.py`**: Main Flask application code.
- **`docker-compose.yaml`**: Configuration for Docker Compose to run the web app and PostgreSQL database.
- **`Dockerfile`**: Docker image definition for the Flask application.
- **`requirements.txt`**: Python dependencies for the Flask app.

---

## Setup Instructions

### Prerequisites

1. Install [Docker](https://docs.docker.com/get-docker/) and [Docker Compose](https://docs.docker.com/compose/install/).
2. Clone this repository.

---

### Step 1: Database Initialization

The PostgreSQL database will be initialized automatically using the `init.sql` file when the Docker container for the database starts.

#### Sample Data in `init.sql`
```sql
CREATE TABLE Timetable (
    id serial PRIMARY KEY,
    course_name VARCHAR(255),
    day VARCHAR(50),
    time VARCHAR(50),
    room VARCHAR(50),
    level INT
);

INSERT INTO Timetable (id, course_name, day, time, room, level) VALUES
(1, 'Computer Languages', 'Monday', '02:00p - 04:20p', 'Room 114', 3),
(2, 'Computer and Information', 'Thursday', '04:30p - 06:50p', 'Room 114', 3),
(3, 'Introduction to', 'Friday', '02:00p - 04:20p', 'Room 409', 3),
(4, 'Global Social Problems', 'Monday', '07:00p - 09:20p', 'Room 108', 3),
(5, 'Operating Systems', 'Monday', '04:30p - 06:50p', 'Room 304', 3),
(6, 'Culture and Communication', 'Friday', '04:30p - 06:50p', 'WebNet+', 3);
```

Step 2: Docker Compose Setup
The docker-compose.yaml file defines two services:

db: PostgreSQL database service.
web: Flask web application service.
To run the project, use the following commands:
```bash
# Build and start the services
docker-compose up --build

# Stop the services
docker-compose down
```
Step 3: Access the Web Application
Once the services are up, access the application at:
```
http://127.0.0.1:8000
```
Application Details

app.py: Flask Application Code
The Flask application connects to the PostgreSQL database using psycopg2 and serves two main routes:

/ (Main Page): Displays a form for users to select a level.
/timetable: Fetches and displays the timetable for the selected level.

```app.py
from flask import Flask, render_template, request
import psycopg2
import os

template_dir = os.path.abspath('templates/')
app = Flask(__name__, template_folder=template_dir)

conn = psycopg2.connect(
        host="db",
        database="komronbek",
        user='postgres',
        password='12345Qa!')

cur = conn.cursor()

@app.route("/", methods=["GET", "POST"])
def index():
    if request.method == "POST":
        level = request.form["level"]
        return render_template("timetable.html", level=level, data=[], message="Loading timetable...")
    return render_template("index.html")

@app.route("/timetable", methods=["GET"])
def timetable():
    level = request.args.get("level")
    query = f"SELECT * FROM Timetable WHERE level = {level};"
    cur.execute(query)
    rows = cur.fetchall()
    message = "No data found for this level." if not rows else None
    return render_template("timetable.html", data=rows, message=message)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000, debug=True)

```
HTML Templates
index.html: Provides a dropdown menu for selecting levels.
```html
<!DOCTYPE html>
<html>
<head>
    <title>Mini project of <Komronbek></title>
</head>
<body>
    <h1>Welcome to the University Timetable!</h1>
    <form action="/timetable" method="GET">
        <label for="level">Select Level:</label>
        <select name="level" id="level">
            <option value="1">Level 1</option>
            <option value="2">Level 2</option>
            <option value="3">Level 3</option>
        </select>
        <button type="submit">Submit</button>
    </form>
</body>
</html>

```
timetable.html: Displays the fetched timetable in a table format.
```html
<!DOCTYPE html>
<html>
<head>
    <title>Timetable</title>
</head>
<body>
    <h2>Timetable for Level {{ level }}</h2>
    {% if data %}
    <table border="1">
        <tr>
            <th>Course ID</th>
            <th>Course Name</th>
            <th>Day</th>
            <th>Time</th>
            <th>Room</th>
        </tr>
        {% for row in data %}
        <tr>
            <td>{{ row[0] }}</td>
            <td>{{ row[1] }}</td>
            <td>{{ row[2] }}</td>
            <td>{{ row[3] }}</td>
            <td>{{ row[4] }}</td>
        </tr>
        {% endfor %}
    </table>
    {% else %}
    <p>{{ message }}</p>
    {% endif %}
</body>
</html>
```
Dockerfile: Flask App Container
```
FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

COPY . .

CMD ["python", "app.py"]
```
docker-compose.yaml: Service Configuration
```
version: '3.8'
services:
  db:
    image: postgres:latest
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: 12345Qa!
      POSTGRES_DB: komronbek
    ports:
      - "5433:5432"
    volumes:
      - ./db-scripts:/docker-entrypoint-initdb.d
  web:
    build: .
    ports:
      - "8000:8000"
    depends_on:
      - db
```
Requirements
Add the following to requirements.txt:
```
blinker==1.9.0
click==8.1.7
Flask==3.1.0
itsdangerous==2.2.0
Jinja2==3.1.4
MarkupSafe==3.0.2
Werkzeug==3.1.3
psycopg2-binary
```
Stopping Services
To stop the containers, run:
```
docker-compose down
```






