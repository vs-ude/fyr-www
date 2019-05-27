#!/bin/bash

cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1
cd ../

if [ -d .git ]; then
	git config core.hooksPath ./dev/hooks
	printf "Successfully installed the git hooks for this repository.\n"
else
	printf "Git hooks could not be installed.\n"
	exit 1
fi
