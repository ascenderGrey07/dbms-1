const API_KEY = "your_tmdb_api_key";
const BASE_URL = "https://api.themoviedb.org/3";

// Function to fetch recommended movies
async function fetchRecommendedMovies() {
    const response = await fetch(${BASE_URL}/movie/popular?api_key=${API_KEY});
    const data = await response.json();
    displayMovies(data.results);
}

// Display movies in the UI
function displayMovies(movies) {
    const container = document.getElementById("movie-container");
    container.innerHTML = "";
    
    movies.forEach(movie => {
        const movieDiv = document.createElement("div");
        movieDiv.classList.add("movie");
        movieDiv.innerHTML = <img src="https://image.tmdb.org/t/p/w500${movie.poster_path}" alt="${movie.title}">;
        movieDiv.addEventListener("click", () => fetchMovieDetails(movie.id));
        container.appendChild(movieDiv);
    });
}

// Fetch and display movie details
async function fetchMovieDetails(movieId) {
    const response = await fetch(${BASE_URL}/movie/${movieId}?api_key=${API_KEY});
    const movie = await response.json();

    document.getElementById("movie-bg").src = https://image.tmdb.org/t/p/original${movie.backdrop_path};
    document.getElementById("character-img").src = "path_to_character_png"; // Placeholder for PNG
    document.getElementById("movie-title").innerText = movie.title;
    document.getElementById("movie-description").innerText = movie.overview;
    document.getElementById("movie-details").style.display = "block";
}

// Load recommended movies on page load
fetchRecommendedMovies();