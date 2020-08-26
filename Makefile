.ONESHELL:
SHELL := /bin/bash

SRC = $(wildcard nbs/*.ipynb)

all: blaze_torch 

both: blaze_torch docs

help:
	cat Makefile

blaze_torch: $(SRC)
	nbdev_clean_nbs
	nbdev_build_lib
	touch blaze_torch

update_lib:
	pip install nbdev --upgrade

docs_serve: docs
	cd docs && bundle exec jekyll serve

docs: $(SRC)
	rsync -a docs_src/ docs
	nbdev_build_docs
	touch docs

test:
	nbdev_test_nbs --pause 0.5 --flags ''

release: pypi
	nbdev_conda_package --upload_user blaze_torch --build_args '-c pytorch -c blaze_torch'
	nbdev_bump_version

pypi: dist
	twine upload --repository pypi dist/*

dist: clean
	python setup.py sdist bdist_wheel

clean:
	rm -rf dist
