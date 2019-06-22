#!/usr/bin/env bash

tr ' ' '\n' | sort | uniq -c | sort -n
