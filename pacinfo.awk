#!/bin/awk -f

BEGIN {
	pat = "^"sect;
}

/^[^[:space:]]/ {
	p = 0;
}

$0 ~ pat {
	p = 1;
	sub(/^[^:]+: /, "");
}

p {
	sub(/^[[:space:]]+/, "");
	print;
}

