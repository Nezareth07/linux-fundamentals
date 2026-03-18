import os
import socket
import redis
import psycopg2
from flask import Flask

app = Flask(__name__)

REDIS_HOST = os.getenv("REDIS_HOST", "localhost")
DB_HOST = os.getenv("DB_HOST", "localhost")
DB_NAME = os.getenv("DB_NAME", "appdb")
DB_USER = os.getenv("DB_USER", "appuser")
DB_PASS = os.getenv("DB_PASS", "apppass")

def get_redis():
    return redis.Redis(host=REDIS_HOST, port=6379, decode_responses=True)

def get_db():
    return psycopg2.connect(
        host=DB_HOST, dbname=DB_NAME,
        user=DB_USER, password=DB_PASS
    )

@app.route('/')
def home():
    # Contador de visitas en Redis
    r = get_redis()
    visitas = r.incr("visitas")

    return {
        "message": "Hello from Docker Compose!",
        "hostname": socket.gethostname(),
        "version": os.getenv("APP_VERSION", "2.0.0"),
        "visitas": visitas
    }

@app.route('/health')
def health():
    status = {"app": "ok", "redis": "error", "db": "error"}

    try:
        r = get_redis()
        r.ping()
        status["redis"] = "ok"
    except Exception:
        pass

    try:
        conn = get_db()
        conn.close()
        status["db"] = "ok"
    except Exception:
        pass

    return status

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)
