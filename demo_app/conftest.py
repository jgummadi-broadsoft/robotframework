import base64
import os
import tempfile

import pytest
import json

from demo_app import create_app
from demo_app.db import get_db
from demo_app.db import init_db

with open(os.path.join(os.path.dirname(__file__), "schema.sql"), "rb") as f:
    _data_sql = f.read().decode("utf8")

@pytest.fixture
def app():
    db_fd, db_path = tempfile.mkstemp()
    app = create_app({"TESTING": True, "DATABASE": db_path})

    with app.app_context():
        init_db()
        get_db().executescript(_data_sql)

    yield app

    os.close(db_fd)
    os.unlink(db_path)

@pytest.fixture
def client(app):
    """A test client for the app."""
    return app.test_client()

@pytest.fixture
def runner(app):
    """A test runner for the app's Click commands."""
    return app.test_cli_runner()

class UserAuth(object):
    def __init__(self, client):
        self._client = client

    def userlogin(self, username="test", password="test"):
        return self._client.post(
            "/auth/login", data={"username": username, "password": password}
        )

    def apitoken(self, username="test"):
        valid_credentials = base64.b64encode(b'test:test').decode('utf-8')
        return self._client.get(
            "/api/auth/token", headers={'Authorization': 'Basic ' + valid_credentials}
        )

    def validusername(self, username="test", password="test"):
        credentials = username + ":" + password
        valid_credentials = base64.b64encode(credentials.encode('utf-8')).decode('utf-8')
        response = self._client.get("/api/auth/token", data={"username": username}, headers={'Authorization': 'Basic ' + valid_credentials})
        if(response.status_code == 200):
            my_json = response.data.decode('utf_8')
            data_dict = json.loads(my_json)
            token_value = data_dict['token']
            head = {'token': token_value}
            return self._client.get("/api/users/test", headers=head)
        else:
            return response

    def validuserupdate(self, username="test", password="test", firstname="aaaaa", lastname="uuuuu", phone="11111"):
        credentials = username + ":" + password
        valid_credentials = base64.b64encode(credentials.encode('utf-8')).decode('utf-8')
        response = self._client.get("/api/auth/token", data={"username": username}, headers={'Authorization': 'Basic ' + valid_credentials})
        if(response.status_code == 200):
            my_json = response.data.decode('utf_8')
            data_dict = json.loads(my_json)
            token_value = data_dict['token']
            head = {'token': token_value}
            return self._client.put("/api/users/test", data=json.dumps(dict(firstname=firstname, lastname=lastname,  phone=phone)), content_type='application/json', headers=head)
        else:
            return response

    def wronguserupdate(self, username="test", password="test", firstname="aaaaa", lastname="uuuuu", phone="11111"):
        credentials = username + ":" + password
        valid_credentials = base64.b64encode(credentials.encode('utf-8')).decode('utf-8')
        response = self._client.get("/api/auth/token", data={"username": username}, headers={'Authorization': 'Basic ' + valid_credentials})
        if(response.status_code == 200):
            my_json = response.data.decode('utf_8')
            data_dict = json.loads(my_json)
            token_value = data_dict['token']
            head = {'token': token_value}
            return self._client.put("/api/users/test", data=json.dumps(dict(firstname=firstname, lastname=lastname,  phones=phone)), content_type='application/json', headers=head)
        else:
            return response

    def logout(self):
        return self._client.get("/auth/logout")

@pytest.fixture
def auth(client):
    return UserAuth(client)
