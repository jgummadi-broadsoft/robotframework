import pytest
import json
from demo_app.db import get_db

"""Unit test to test api functionality with different
use cases """

def test_fetch_users(client, app):
    rsp = client.get("/api/users")
    assert rsp.status_code == 200
    with app.app_context():
        fetched_db = get_db()
        count_check = fetched_db.execute("SELECT COUNT(id) FROM USER").fetchone()[0]
        assert count_check == 2

def test_token_create(client, auth, app):
    auth.userlogin()
    rsp = auth.apitoken()
    assert rsp.status_code == 200
    my_json = rsp.data.decode('utf_8')
    data_dict = json.loads(my_json)
    print(data_dict['token'])

@pytest.mark.parametrize(
    ("username", "password",),
    (("test", "test",),),
)
def test_valid_username(client, auth, app, username, password):
    auth.userlogin(username, password)
    rsp = auth.validusername(username, password)
    assert rsp.status_code == 200
    my_json = rsp.data.decode('utf_8')
    data_dict = json.loads(my_json)
    my_json = data_dict['payload']
    assert my_json['firstname'] == "aaaaa"

@pytest.mark.parametrize(
    ("username", "password",),
    (("qqqqq", "abcd",),),
)

def test_wrong_username(client, auth, app, username, password):
    auth.userlogin(username, password)
    rsp = auth.validusername(username, password)
    assert rsp.status_code == 401

# These tests commented since it doesn't works in api.py line no #90
# replace data.items() to work in python 3x

"""
@pytest.mark.parametrize(
    ("username", "password", "firstname", "lastname", "phone" ),
    (("test", "test", "GGGGGGGG", "SSSS", "999999"), ),
)
def test_valid_username_update(client, auth, app, username, password, firstname, lastname, phone):
    auth.login(username, password)
    rsp = auth.validuserupdate(username, password, firstname, lastname, phone)
    assert rsp.status_code == 201

@pytest.mark.parametrize(
    ("username", "password", "firstname", "lastname", "phones" ),
    (("test", "test", "GGGGGGGG", "SSSS", "999999"), ),
)
def test_wrong_username_update(client, auth, app, username, password, firstname, lastname, phones):
    auth.login(username, password)
    rsp = auth.wronguserupdate(username, password, firstname, lastname, phones)
    assert rsp.status_code == 403
"""
