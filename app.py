from flask import Flask, jsonify

app = Flask(__name__)


@app.get("/")
def hello() -> str:
    return "Hello from Flask in Docker!"


@app.get("/health")
def health() -> tuple:
    return jsonify(status="ok"), 200


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
