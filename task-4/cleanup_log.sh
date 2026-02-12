#!/bin/bash

find "$(pwd)/metrics" -name "metrics_agg_*.log" -mmin +720 -print -delete
