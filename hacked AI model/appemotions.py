from flask import Flask, request, jsonify
import numpy as np
import pandas as pd
from tensorflow.keras.preprocessing.sequence import pad_sequences
from tensorflow.keras.preprocessing.text import Tokenizer
from tensorflow.keras.models import load_model

app = Flask(__name__)
model = load_model('mood_analysis_model.h5')
tokenizer = Tokenizer()
tokenizer.fit_on_texts(pd.read_csv('journal_dataset1.csv')['Answer'])

Max_VOCAB_SIZE = 20000
T = 224

@app.route('/predict_emotion', methods=['POST'])
def predict_emotion():
    if isinstance(request.json, str):
        try:
            input_text = request.json['text']
        except KeyError:
            return jsonify({'error': 'Invalid JSON format. Missing key: text'}), 400
    else:
        input_text = request.json.get('text', '')

    sequences = tokenizer.texts_to_sequences([input_text])
    padded_sequence = pad_sequences(sequences, maxlen=T)

    predictions = model.predict(padded_sequence)

    if predictions < 0.3:
        emotion = "very sad"
    elif predictions < 0.4:
        emotion = "sad"
    elif predictions < 0.6:
        emotion = "neutral"
    elif predictions > 0.6:
        emotion = "happy"

    return jsonify({
        'emotion': emotion,
        'percentage': float(predictions[0])

    })

if __name__ == '__main__':
    app.run(debug=True, port=5000)
