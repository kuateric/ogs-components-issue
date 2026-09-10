+++
date = "{{ .Date }}"
title = "OpenGeoSys {{ .File.ContentBaseName }}"
tag = "{{ .File.ContentBaseName }}"
author = "Lars Bilke"
release_date = "{{ .Date }}"

[downloads]
binary = [
"Windows-10.0.22631-python-3.12.1-de-utils.zip",
"Windows-10.0.22631-python-3.12.1-utils.zip",
]
container = [
"serial.squashfs",
"petsc.squashfs",
"serial-mkl.squashfs",
"petsc-mkl.squashfs",
]
pip = true
note = """
**Note:** When using Python bindings make sure to have Python installed on your system:

- Windows: [Python 3.12.1](https://www.python.org/ftp/python/3.12.1/python-3.12.1-amd64.exe)
"""
+++
