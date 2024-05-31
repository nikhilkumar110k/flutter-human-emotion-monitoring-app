import pandas as pd
import nltk
from nltk.stem.porter import PorterStemmer
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
from flask import Flask, request, jsonify
import pickle

app = Flask(__name__)

df = pd.read_csv('spotify_millsongdata.csv').sample(40000)
df.drop('link',axis=1).reset_index(drop=True)
df['text']= df['text'].sample(40000).str.lower().replace(r'^\w\s',' ').replace(r'\n',' ', regex=True)

stemmer= PorterStemmer()

def token(txt):
    token= nltk.word_tokenize(txt)
    for w in token:
        a= stemmer.stem(w) 
    return " ".join(a)

df['text'].apply(lambda x: token(str(x)))

tfidf= TfidfVectorizer(analyzer='word', stop_words='english')
df['text'].fillna('', inplace=True)
matrix= tfidf.fit_transform(df['text'])
similar= cosine_similarity(matrix)

def recommender(song_name):
    matching_rows = df[df['song'] == song_name]
    if len(matching_rows) == 0:
        return [] 
    idx = matching_rows.index[0]
    distance = sorted(list(enumerate(similar[idx])), reverse=True, key=lambda x: x[1])
    songs = [df.iloc[s_id[0]]['song'] for s_id in distance[1:10]]
    return songs

@app.route('/recommend_song', methods=['POST'])
def recommend_song():
    song_name = request.json['song_name']
    recommended_songs = recommender(song_name)
    return jsonify({
        'song_name': song_name,
        'recommended_songs': recommended_songs
    })

if __name__ == '__main__':
    app.run(debug=False, port=6000)
