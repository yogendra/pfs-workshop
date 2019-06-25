#!/usr/bin/env bash

source `dirname $0`/variables.sh

SCRIPT_ROOT=$(cd  `dirname $0`; pwd)

function cheatsheet {
    id=$1
cat <<EOF
<tr>
<td>user-$id</td>
<td><code style="white-space: pre;">
export WS_USER=user-$id
export WS_DOMAIN=\$WS_USER-ns.pfs.atwater.cf-app.com
curl -sL https://github.com/yogendra/pfs-workshop/raw/master/setup-environment/users/\$WS_USER/config -o \$HOME/.kube/config
<code>
</td>
</tr>
EOF

}

run cheatsheet $*
