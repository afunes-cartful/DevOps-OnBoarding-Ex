#!/bin/bash
curl -LI http://api-env.cartfulsolutions.com/staging/status -o /dev/null -w '%{http_code}\n' -s