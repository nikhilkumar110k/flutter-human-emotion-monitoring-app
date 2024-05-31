from flask import Flask, request, jsonify, render_template
import numpy as np
import pandas as pd
import nltk
from nltk.stem.porter import PorterStemmer
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
from tensorflow.keras.preprocessing.sequence import pad_sequences
from tensorflow.keras.preprocessing.text import Tokenizer
from tensorflow.keras.models import load_model

app = Flask(__name__)


emotion_model = load_model('mood_analysis_model.h5')


df = pd.read_csv('spotify_millsongdata.csv').sample(25000)
df.drop('link', axis=1, inplace=True)
df['text'] = df['text'].sample(5000).str.lower().replace(r'^\w\s', ' ').replace(r'\n', ' ', regex=True)


tokenizer = Tokenizer()
tokenizer.fit_on_texts(pd.read_csv('journal_dataset1.csv')['Answer'])

Max_VOCAB_SIZE = 20000
T = 224
stemmer = PorterStemmer()

def token(txt):
    tokens = nltk.word_tokenize(txt)
    for w in tokens:
        a = stemmer.stem(w)
    return " ".join(tokens)

if not df.empty:
    df['text'] = df['text'].apply(lambda x: token(str(x)))

    tfidf = TfidfVectorizer(analyzer='word', stop_words='english')
    df['text'].fillna('', inplace=True)
    matrix = tfidf.fit_transform(df['text'])
    similar = cosine_similarity(matrix)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/predict_emotion', methods=['POST'])
def predict_emotion():
    if emotion_model is None or tokenizer is None or df.empty:
        return jsonify({'error': 'Model, tokenizer, or dataset not loaded properly'}), 500

    input_text = request.json.get('text', '')

    sequences = tokenizer.texts_to_sequences([input_text])
    padded_sequence = pad_sequences(sequences, maxlen=T)

    predictions = emotion_model.predict(padded_sequence)

    if predictions < 0.3:
        emotion = "very sad"
    elif predictions < 0.5:
        emotion = "sad"
    elif predictions < 0.7:
        emotion = "neutral"
    elif predictions > 0.7:
        emotion = "happy"

    recommended_songs = recommender1(emotion)

    return jsonify({
        'emotion': emotion,
        'percentage': float(predictions[0]),
        'recommended_songs': recommended_songs if recommended_songs else []
    })

def recommender(song_name):
    if df.empty:
        return []

    matching_rows = df[df['song'] == song_name]
    if len(matching_rows) == 0:
        return []
    
    idx = matching_rows.index[0]
    if idx >= len(similar):
        return []
    distance = sorted(list(enumerate(similar[idx])), reverse=True, key=lambda x: x[1])
    if len(distance) <= 1:
        return []
    
    songs = [df.iloc[s_id[0]]['song'] for s_id in distance[1:10]]
    return songs

def recommender1(emotion):
    if emotion == "very sad":
        return [recommend_song("Happy")]
    elif emotion == "sad":
        return [recommend_song("Someone Like You")]
    elif emotion == "neutral":
        return [recommender("Crazy Little Thing Called Love")]
    else:  
        return [recommender("Eye of the Tiger")]

def recommend_song(songs):
    song_name = songs
    recommended_songs = recommender(song_name)
    return {
        'song_name': song_name,
        'recommended_songs': recommended_songs
    }

if __name__ == '__main__':
    app.run(debug=True, port=3000)
