SCRIPT_NAME = packageLaunch.py
SCRIPT_PARAM ?=
PY ?= python
SOURCE ?= .
VENV_DIR_PROD ?= .venv.prod
VENV_DIR_DEV ?= .venv.dev
REQUIREMENTS_PROD = requirements.prod.txt
REQUIREMENTS_DEV = requirements.dev.txt

.DEFAULT_GOAL := run

run: venv_prod
	@( \
		$(SOURCE) $(VENV_DIR_PROD)/bin/activate; \
		$(PY) $(SCRIPT_NAME) $(SCRIPT_PARAM); \
	)


# Check code for best standards
# flake8 --ignore=E501,F401 --max-complexity 10 --exclude .venv,.git,__pycache__ .
check: venv_dev
	@echo Checking code standards...
	@( \
		$(SOURCE) $(VENV_DIR_DEV)/bin/activate; \
		flake8 --ignore=E501,W503 --max-complexity 10 --exclude $(VENV_DIR_PROD),$(VENV_DIR_DEV),.git,__pycache__ . || exit 1; \
	)


venv_dev: $(VENV_DIR_DEV)/touchfile
venv_prod: $(VENV_DIR_PROD)/touchfile


# Create .venv if it doesn't exist - `test -d .venv.dev || python -m venv .venv.dev`
# Activate venv and install requirements inside - `source .venv/bin/activate && pip install -r requirements.txt
# Create `.venv/touchfile` so that this is ran only if requirements file changes
$(VENV_DIR_DEV)/touchfile: $(REQUIREMENTS_DEV)
	test -d $(VENV_DIR_DEV) || $(PY) -m venv $(VENV_DIR_DEV)
	$(SOURCE) $(VENV_DIR_DEV)/bin/activate && $(PY) -m pip install -r $(REQUIREMENTS_DEV)
	touch $(VENV_DIR_DEV)/touchfile


# Create .venv if it doesn't exist - `test -d .venv.dev || python -m venv .venv.dev`
# Activate venv and install requirements inside - `source .venv/bin/activate && pip install -r requirements.txt
# Create `.venv/touchfile` so that this is ran only if requirements file changes
$(VENV_DIR_PROD)/touchfile: $(REQUIREMENTS_PROD)
	test -d $(VENV_DIR_PROD) || $(PY) -m venv $(VENV_DIR_PROD)
	$(SOURCE) $(VENV_DIR_PROD)/bin/activate && $(PY) -m pip install -r $(REQUIREMENTS_PROD)
	touch $(VENV_DIR_PROD)/touchfile