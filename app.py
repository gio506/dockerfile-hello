from flask import Flask, jsonify

app = Flask(__name__)


@app.get("/")
def hello() -> tuple[dict[str, str], int]:
    return {"message": "Hello from dockerfile-hello"}, 200


@app.get("/health")
def health() -> tuple[dict[str, str], int]:
    return jsonify(status="ok"), 200


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
