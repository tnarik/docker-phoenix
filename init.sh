#!/bin/bash
/etc/init.d/postgresql start

exec "$@"