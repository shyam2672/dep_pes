from application import init_app
# from flask import Flask
from scheduler import Scheduler

app = init_app()
# app = Flask(__name__)
with app.app_context():
    app.config['scheduler'] = Scheduler(app)

if __name__ == "__main__":
    print('Started Server')
    app.run()
