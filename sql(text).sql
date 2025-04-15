-- Drop tables if they already exist (to avoid duplication errors)
DROP TABLE IF EXISTS Users, Movies, Genres, MovieGenres, Reviews, Watchlist, Recommendations, Actors, MovieActors, Trailers;

-- Users Table
CREATE TABLE Users (
    user_id NUMBER PRIMARY KEY,
    username VARCHAR2(50) UNIQUE NOT NULL,
    email VARCHAR2(100) UNIQUE NOT NULL,
    password_hash VARCHAR2(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Movies Table
CREATE TABLE Movies (
    movie_id NUMBER PRIMARY KEY,
    title VARCHAR2(255) NOT NULL,
    release_year NUMBER,
    description CLOB,
    rating NUMBER(3,1),
    poster_url VARCHAR2(500),
    background_url VARCHAR2(500),
    trailer_url VARCHAR2(500)
);

-- Genres Table
CREATE TABLE Genres (
    genre_id NUMBER PRIMARY KEY,
    genre_name VARCHAR2(100) UNIQUE NOT NULL
);

-- MovieGenres (Many-to-Many Relationship)
CREATE TABLE MovieGenres (
    movie_id NUMBER REFERENCES Movies(movie_id) ON DELETE CASCADE,
    genre_id NUMBER REFERENCES Genres(genre_id) ON DELETE CASCADE,
    PRIMARY KEY (movie_id, genre_id)
);

-- Reviews Table
CREATE TABLE Reviews (
    review_id NUMBER PRIMARY KEY,
    user_id NUMBER REFERENCES Users(user_id) ON DELETE CASCADE,
    movie_id NUMBER REFERENCES Movies(movie_id) ON DELETE CASCADE,
    rating NUMBER(3,1) CHECK (rating BETWEEN 0 AND 10),
    comment CLOB,
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Watchlist Table
CREATE TABLE Watchlist (
    watchlist_id NUMBER PRIMARY KEY,
    user_id NUMBER REFERENCES Users(user_id) ON DELETE CASCADE,
    movie_id NUMBER REFERENCES Movies(movie_id) ON DELETE CASCADE,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Recommendations Table
CREATE TABLE Recommendations (
    recommendation_id NUMBER PRIMARY KEY,
    user_id NUMBER REFERENCES Users(user_id) ON DELETE CASCADE,
    movie_id NUMBER REFERENCES Movies(movie_id) ON DELETE CASCADE,
    recommended_movie_id NUMBER REFERENCES Movies(movie_id) ON DELETE CASCADE
);

-- Actors Table
CREATE TABLE Actors (
    actor_id NUMBER PRIMARY KEY,
    actor_name VARCHAR2(255) UNIQUE NOT NULL
);

-- MovieActors (Many-to-Many Relationship)
CREATE TABLE MovieActors (
    movie_id NUMBER REFERENCES Movies(movie_id) ON DELETE CASCADE,
    actor_id NUMBER REFERENCES Actors(actor_id) ON DELETE CASCADE,
    PRIMARY KEY (movie_id, actor_id)
);

-- Trailers Table
CREATE TABLE Trailers (
    trailer_id NUMBER PRIMARY KEY,
    movie_id NUMBER REFERENCES Movies(movie_id) ON DELETE CASCADE,
    trailer_url VARCHAR2(500) NOT NULL
);

-- Insert Sample Data for Users
INSERT INTO Users (user_id, username, email, password_hash) VALUES 
(1, 'john_doe', 'john@example.com', 'hashedpassword123'),
(2, 'emma_watson', 'emma@example.com', 'securepassword456');

-- Insert Sample Data for Movies
INSERT INTO Movies (movie_id, title, release_year, description, rating, poster_url, background_url, trailer_url) VALUES
(1, 'Inception', 2010, 'A mind-bending thriller about dreams within dreams.', 8.8, 'poster_inception.jpg', 'bg_inception.jpg', 'https://youtu.be/YoHD9XEInc0'),
(2, 'The Dark Knight', 2008, 'Batman faces the Joker in Gotham City.', 9.0, 'poster_darkknight.jpg', 'bg_darkknight.jpg', 'https://youtu.be/EXeTwQWrcwY'),
(3, 'Interstellar', 2014, 'A journey through space and time.', 8.6, 'poster_interstellar.jpg', 'bg_interstellar.jpg', 'https://youtu.be/zSWdZVtXT7E');

-- Insert Sample Data for Genres
INSERT INTO Genres (genre_id, genre_name) VALUES 
(1, 'Action'),
(2, 'Sci-Fi'),
(3, 'Drama'),
(4, 'Thriller');

-- Link Movies to Genres
INSERT INTO MovieGenres (movie_id, genre_id) VALUES
(1, 2), -- Inception (Sci-Fi)
(1, 4), -- Inception (Thriller)
(2, 1), -- The Dark Knight (Action)
(2, 4), -- The Dark Knight (Thriller)
(3, 2), -- Interstellar (Sci-Fi)
(3, 3); -- Interstellar (Drama)

-- Insert Sample Data for Reviews
INSERT INTO Reviews (review_id, user_id, movie_id, rating, comment) VALUES
(1, 1, 1, 9, 'Amazing movie with a great concept!'),
(2, 2, 2, 10, 'Best Batman movie ever!'),
(3, 1, 3, 8, 'Visually stunning and thought-provoking.');

-- Insert Sample Data for Watchlist
INSERT INTO Watchlist (watchlist_id, user_id, movie_id) VALUES
(1, 1, 2), -- John added The Dark Knight
(2, 2, 3); -- Emma added Interstellar

-- Insert Sample Data for Recommendations
INSERT INTO Recommendations (recommendation_id, user_id, movie_id, recommended_movie_id) VALUES
(1, 1, 1, 3), -- If John liked Inception, recommend Interstellar
(2, 2, 2, 1); -- If Emma liked The Dark Knight, recommend Inception

-- Insert Sample Data for Actors
INSERT INTO Actors (actor_id, actor_name) VALUES 
(1, 'Leonardo DiCaprio'),
(2, 'Christian Bale'),
(3, 'Matthew McConaughey');

-- Link Movies to Actors
INSERT INTO MovieActors (movie_id, actor_id) VALUES
(1, 1), -- Leonardo DiCaprio in Inception
(2, 2), -- Christian Bale in The Dark Knight
(3, 3); -- Matthew McConaughey in Interstellar

-- Insert Sample Data for Trailers
INSERT INTO Trailers (trailer_id, movie_id, trailer_url) VALUES
(1, 1, 'https://youtu.be/YoHD9XEInc0'),
(2, 2, 'https://youtu.be/EXeTwQWrcwY'),
(3, 3, 'https://youtu.be/zSWdZVtXT7E');

-- Create Indexes for Faster Queries
CREATE INDEX idx_movies_title ON Movies(title);
CREATE INDEX idx_users_email ON Users(email);
CREATE INDEX idx_genres_name ON Genres(genre_name);
CREATE INDEX idx_reviews_movie_id ON Reviews(movie_id);
CREATE INDEX idx_watchlist_user_id ON Watchlist(user_id);
CREATE INDEX idx_recommendations_user_id ON Recommendations(user_id);