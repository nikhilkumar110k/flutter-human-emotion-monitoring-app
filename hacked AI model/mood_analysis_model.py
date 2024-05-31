import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
from tensorflow.keras.preprocessing.text import Tokenizer
from tensorflow.keras.preprocessing.sequence import pad_sequences
from tensorflow.keras.layers import Dense, Input, GlobalMaxPooling1D
from tensorflow.keras.layers import LSTM, Embedding
from tensorflow.keras.models import Model

df = pd.read_csv(r'journal_dataset1.csv')


emotions_columns = [
    'Answer.f1.happy.raw',
    'Answer.f1.sad.raw'
]

df_emotions = df[emotions_columns].any(axis=1).astype(int)
print(df_emotions)
df_train, df_test, Ytrain, Ytest = train_test_split(df['Answer'], df_emotions, test_size=0.25)

Max_VOCAB_SIZE = 20000
tokenizer = Tokenizer(num_words=Max_VOCAB_SIZE)
tokenizer.fit_on_texts(df_train)
sequences_train = tokenizer.texts_to_sequences(df_train)
sequences_test = tokenizer.texts_to_sequences(df_test)
data_train = pad_sequences(sequences_train)
data_test = pad_sequences(sequences_test, maxlen=data_train.shape[1]) 
D = 20
M = 15
V = len(tokenizer.word_index)
T = data_train.shape[1]
def preprocessing(sentence, tokenizer, maxlen):
    sequences = tokenizer.texts_to_sequences([sentence])
    padded_sequence = pad_sequences(sequences, maxlen=maxlen)
    return padded_sequence

i = Input(shape=(T,))
x = Embedding(V + 1, D)(i)
x = LSTM(M, return_sequences=True)(x)
x = GlobalMaxPooling1D()(x)
x = Dense(1, activation='sigmoid')(x)
model = Model(i, x)

model.compile(
    loss='binary_crossentropy',
    optimizer='adam',
    metrics=['accuracy']
)

r = model.fit(data_train, Ytrain, epochs=20, validation_data=(data_test, Ytest))
answer= "i gave an LR test and it didn't go well"
answer_preprocessed=preprocessing(answer,tokenizer,T)

predictions = model.predict(answer_preprocessed)

print(predictions)

if predictions < 0.3 and predictions < 0.5:
        print("you are very sad")
if predictions < 0.5 and predictions > 0.3:       
        print("you are sad")
if predictions > 0.7:
        print("you are happy")
if predictions > 0.5 and predictions<0.7:
        print("you are neutral")


