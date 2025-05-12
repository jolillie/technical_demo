from flask import Flask, render_template, request, redirect, abort
from pymongo import MongoClient, errors
from datetime import datetime
import os
import logging
from random import choice

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s %(levelname)s: %(message)s')

app = Flask(__name__)

# Connect to MongoDB
try:
    MONGO_URI = os.getenv("MONGO_URI", "mongodb://localhost:27017")
    client = MongoClient(MONGO_URI, serverSelectionTimeoutMS=5000)
    client.admin.command('ping')  # Verify connection
    db = client.quote_db
    quotes = db.quotes
    logging.info("Connected to MongoDB at %s", MONGO_URI)
except errors.ConnectionFailure as e:
    logging.error("Failed to connect to MongoDB: %s", str(e))
    raise SystemExit("MongoDB connection error")

@app.route('/')
def index():
    try:
        recent_quotes = list(quotes.find().sort("timestamp", -1).limit(10))
        all_quotes = list(quotes.find())
        random_quote = choice(all_quotes) if all_quotes else None
        return render_template('index.html', quotes=recent_quotes, random_quote=random_quote)
    except Exception as e:
        logging.exception("Failed to retrieve quotes: %s", str(e))
        return "Internal Server Error", 500

@app.route('/add', methods=['GET', 'POST'])
def add_quote():
    if request.method == 'POST':
        quote_text = request.form.get('quote', '').strip()
        author = request.form.get('author', '').strip()
        category = request.form.get('category', '').strip()

        if not quote_text or not author:
            logging.warning("Empty quote or author submitted")
            return "Quote and author cannot be empty", 400

        try:
            quotes.insert_one({
                "quote": quote_text,
                "author": author,
                "category": category,
                "timestamp": datetime.utcnow()
            })
            logging.info("Inserted quote by %s", author)
        except Exception as e:
            logging.exception("Failed to insert quote: %s", str(e))
            return "Failed to add quote", 500

        return redirect('/')

    return render_template('add.html')

@app.errorhandler(404)
def not_found_error(e):
    logging.warning("404 Not Found: %s", request.path)
    return "Page not found", 404

@app.errorhandler(500)
def internal_error(e):
    logging.error("500 Internal Server Error: %s", str(e))
    return "Internal Server Error", 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
