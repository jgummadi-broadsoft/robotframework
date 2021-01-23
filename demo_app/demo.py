from flask import (
    Blueprint, flash, g, redirect, render_template, request, url_for
)
from werkzeug.exceptions import abort

from demo_app.auth import login_required
from demo_app.db import get_db

bp = Blueprint('demo', __name__)


@bp.route('/')
def index():
    return render_template('demo/index.html')

@bp.route('/user')
def user_page():
    return render_template('auth/user.html')
