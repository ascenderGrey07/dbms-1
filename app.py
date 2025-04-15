from flask import Flask, jsonify, request
from flask_cors import CORS
import mysql.connector
import requests

app = Flask(_name_)
CORS(app)  # Enable Cross-Origin Resource Sharing

# TMDB API Key
API_KEY = "your_tmdb_api_key"
BASE_URL = "https://api.themoviedb.org/3"

# Database Connection
db = mysql.connector.connect(
    host="localhost",
    user="your_username",
    password="your_password",
    database="movie_db"
)
cursor = db.cursor()

# Fetch recommended movies from TMDB API
@app.route("/recommendations", methods=["GET"])
def get_recommendations():
    response = requests.get(f"{BASE_URL}/movie/popular?api_key={API_KEY}")
    data = response.json()
    return jsonify(data["results"])

# Fetch movie details by ID
@app.route("/movie/<int:movie_id>", methods=["GET"])
def get_movie_details(movie_id):
    response = requests.get(f"{BASE_URL}/movie/{movie_id}?api_key={API_KEY}")
    data = response.json()
    return jsonify(data)

# Store user search history in the database
@app.route("/search", methods=["POST"])
def store_search():
    data = request.json
    user_id = data.get("user_id")
    movie_name = data.get("movie_name")
    
    query = "INSERT INTO search_history (user_id, movie_name) VALUES (%s, %s)"
    cursor.execute(query, (user_id, movie_name))
    db.commit()
    
    return jsonify({"message": "Search stored successfully!"})

if _name_ == "_main_":
    app.run(debug=True)