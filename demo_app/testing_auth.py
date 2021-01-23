import pytest
from flask import session
from demo_app.db import get_db

"""Unit test to test register functionality with different
use cases """

def test_register_user(client, app):
    assert client.get("/register").status_code == 200

    rsp = client.post("/register", data={"username": "zzzzzz", "password": "bbbb", "firstname": "aaaaaa", "lastname": "wwww", "phone": "123456"})
    assert "http://localhost/login" == rsp.headers["Location"]

    with app.app_context():
        assert (
            get_db().execute("select * from user where username = 'zzzzzz'").fetchone()
            is not None
        )

@pytest.mark.parametrize(
    ("username", "password", "firstname", "lastname", "phone", "message"),
    (
        ("", "", "", "", "", b"Username is required."),
        ("zzzzzz", "", "", "", "", b"Password is required."),
        ("test", "pbkdf2:sha256:50000$TCI4GzcX$0de171a4f4dac32e3364c7ddc7c14f3e2fa61f2d17574483f7ffbb431b4acb2f", "aaaaaa", "wwww", "123456", b"already registered"),
    ),
)

def test_register_input(client, username, password, firstname, lastname, phone, message):
    rsp = client.post(
        "/register", data={"username": username, "password": password, "firstname": firstname, "lastname": lastname, "phone": phone}
    )
    assert message in rsp.data

def test_login(client, auth):
    assert client.get("/login").status_code == 200

@pytest.mark.parametrize(
    ("username", "password", "message"),
    (("zzzzzz", "test", "http://localhost:8080/error"), ("test", "bbbb", "http://localhost:8080/error")),
)

def test_login_input(auth, username, password, message):
    rsp = auth.userlogin(username, password)
    assert message in rsp.headers["Location"]

def test_logout(client, auth):
    auth.userlogin()
    with client:
        auth.logout()
        assert "id" not in session
