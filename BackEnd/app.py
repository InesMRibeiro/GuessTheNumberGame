from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
import random
import os

app = Flask(__name__)
CORS(app, resources={"/*": {"origins": "http://44.203.0.221"}})  # Allowing only your frontend

DATABASE_IP = os.getenv('DATABASE_IP', '107.23.102.122')  # Substitua pelo IP correto
app.config['SQLALCHEMY_DATABASE_URI'] = f'postgresql://postgres:postgres@{'107.23.102.122'}:5432/WINNERS'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

# Modelo da tabela Scoreboard
class Scoreboard(db.Model):
    __tablename__ = 'scoreboard'
    
    id = db.Column(db.Integer, primary_key=True)
    player_name = db.Column(db.String(255), nullable=False)
    attempts = db.Column(db.Integer, nullable=False)
    win_date = db.Column(db.DateTime, default=db.func.current_timestamp())

# Criar tabelas no banco de dados
with app.app_context():
    db.create_all()

# Game logic
class Game:
    def __init__(self, player_name):
        self.player_name = player_name
        self.secret_number = random.randint(0, 100)  # Number between 0 and 100
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
        # Criar um novo jogo para o jogador
        new_game = Game(player_name)
        games[player_name] = new_game
        return jsonify({"message": f"Bem-vindo, {player_name}! O jogo começou. Tente adivinhar o número entre 0 e 100!"}), 200
    return jsonify({"message": "Nome do jogador é necessário!"}), 400

@app.route('/make_guess', methods=['POST'])
def make_guess():
    data = request.json
    player_name = data.get('player_name')
    player_guess = data.get('player_guess')

    if not player_name or player_guess is None:
        return jsonify({"message": "Nome do jogador e o palpite são necessários!"}), 400

    # Verificar se o jogador iniciou um jogo
    game = games.get(player_name)
    if not game:
        return jsonify({"message": f"Jogador {player_name} não iniciou um jogo. Use /start_game primeiro."}), 400

    # Converter o palpite para inteiro
    try:
        player_guess = int(player_guess)
    except ValueError:
        return jsonify({"message": "Por favor, forneça um número válido como palpite!"}), 400

    # Verificar o palpite do jogador
    result = game.guess(player_guess)

    # Se o jogador acertou, registrar no banco de dados
    if result == "Parabéns, você acertou o número!":
        new_winner = Scoreboard(player_name=player_name, attempts=game.attempts)
        db.session.add(new_winner)
        db.session.commit()
        del games[player_name]  # Remover o jogo após a vitória
        return jsonify({"message": f"Parabéns, {player_name}! Você venceu o jogo em {game.attempts} tentativas!"}), 200
    
    return jsonify({"message": result}), 200

@app.route('/scoreboard', methods=['GET'])
def get_scoreboard():
    top_players = Scoreboard.query.order_by(Scoreboard.attempts.asc()).limit(10).all()
    scoreboard_data = [{"player_name": player.player_name, "attempts": player.attempts, "win_date": player.win_date} for player in top_players]
    return jsonify(scoreboard_data), 200

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
