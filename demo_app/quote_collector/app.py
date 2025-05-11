from flask import Flask, render_template, request, redirect
from pymongo import MongoClient
from datetime import datetime
import os

app = Flask(__name__)

# Connect to MongoDB
MONGO_URI = os.getenv("MONGO_URI", "mongodb://localhost:27017")
client = MongoClient(MONGO_URI)
db = client.quote_db
quotes = db.quotes

@app.route('/')
def index():
    recent_quotes = list(quotes.find().sort("timestamp", -1).limit(10))
    return render_template('index.html', quotes=recent_quotes)

@app.route('/add', methods=['GET', 'POST'])
def add_quote():
    if request.method == 'POST':
        quote_text = request.form['quote']
        author = request.form['author']
        if quote_text.strip() and author.strip():
            quotes.insert_one({
                "quote": quote_text,
                "author": author,
                "timestamp": datetime.utcnow()
            })
        return redirect('/')
    return render_template('add.html')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)