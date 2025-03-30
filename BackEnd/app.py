from flask import Flask, request, jsonify
from flask_cors import CORS
import random

app = Flask(__name__)
CORS(app, resources={"/*": {"origins": "44.211.240.240"}})  # Allowing only your frontend

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
        # Create a new game instance for the player
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

    # Check if the player has an ongoing game
    game = games.get(player_name)
    if not game:
        return jsonify({"message": f"Jogador {player_name} não iniciou um jogo. Use /start_game primeiro."}), 400

    # Convert the guess to an integer
    try:
        player_guess = int(player_guess)
    except ValueError:
        return jsonify({"message": "Por favor, forneça um número válido como palpite!"}), 400

    # Check the player's guess
    result = game.guess(player_guess)

    # If the player guessed correctly, register it in the database (if needed)
    if result == "Parabéns, você acertou o número!":
        return jsonify({"message": f"Parabéns, {player_name}! Você venceu o jogo em {game.attempts} tentativas!"}), 200
    else:
        return jsonify({"message": result}), 200

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
