from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
import random
import os
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

# # Conexão com o banco de dados PostgreSQL
# database_ip = os.getenv('DATABASE_IP')  # Obtém o IP da variável de ambiente

# # Configuração do Flask
# app.config['SQLALCHEMY_DATABASE_URI'] = f'postgresql://postgres:strongpassword@{database_ip}:5432/WINNERS'
# app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
# db = SQLAlchemy(app)

# # Tabela Scoreboard
# class Scoreboard(db.Model):
#     __tablename__ = 'scoreboard'
    
#     id = db.Column(db.Integer, primary_key=True)
#     player_name = db.Column(db.String(255), nullable=False)
#     win_date = db.Column(db.DateTime, default=db.func.current_timestamp())

# Lógica do jogo
class Game:
    def __init__(self, player_name):
        self.player_name = player_name
        self.secret_number = random.randint(0, 100)  # Número aleatório entre 0 e 100
        self.attempts = 0

    def guess(self, player_guess):
        self.attempts += 1
        if player_guess < self.secret_number:
            return "O número que você está procurando é maior."
        elif player_guess > self.secret_number:
            return "O número que você está procurando é menor."
        else:
            return "Parabéns, você acertou o número!"

games = {}

@app.route('/start_game', methods=['POST'])
def start_game():
    data = request.json
    player_name = data.get('player_name')

    if player_name:
        # Criar uma nova instância do jogo para o jogador
        new_game = Game(player_name)
        games[player_name] = new_game
        return jsonify({"message": f"Bem-vindo, {player_name}! O jogo começou. Tente adivinhar o número entre 0 e 100!"}), 200
    return jsonify({"message": "Nome do jogador é necessário!"}), 400

@app.route('/make_guess', methods=['POST'])
def make_guess():
    data = request.json
    player_name = data.get('player_name')
    player_guess = data.get('player_guess')

    # Verificar se o jogador tem um jogo em andamento
    game = games.get(player_name)
    if not game:
        return jsonify({"message": f"Jogador {player_name} não iniciou um jogo. Use /start_game primeiro."}), 400

    # Converter palpite para inteiro
    try:
        player_guess = int(player_guess)
    except ValueError:
        return jsonify({"message": "Por favor, forneça um número válido como palpite!"}), 400

    # Verificar o palpite do jogador
    result = game.guess(player_guess)

    # # # Se o jogador acertou, registra no banco de dados
    # # if result == "Parabéns, você acertou o número!":
    # #     new_winner = Scoreboard(player_name=player_name)
    # #     db.session.add(new_winner)
    # #     db.session.commit()
    # #     return jsonify({"message": f"Parabéns, {player_name}! Você venceu o jogo em {game.attempts} tentativas!"}), 200
    # # else:
    # #     return jsonify({"message": result}), 200

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
