import os

from flask import Flask, jsonify

app = Flask(__name__)
APP_VERSION = os.getenv("APP_VERSION", "1.0.0")


@app.get("/")
def hello() -> tuple[dict[str, str], int]:
    return {"message": "Hello from dockerfile-hello"}, 200


@app.get("/health")
def health() -> tuple[dict[str, str], int]:
    return jsonify(status="ok"), 200


@app.get("/version")
def version() -> tuple[dict[str, str], int]:
    return jsonify(version=APP_VERSION), 200


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
