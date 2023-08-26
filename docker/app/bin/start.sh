#!/bin/bash

# 各種サービス起動
sudo su <<EOF
service postfix start
EOF

# 使用できないセッションの削除
screen -wipe

# セッションの作成
screen -dmS vite
screen -dmS queue
screen -dmS serve

# vite セッションで vite を用いた自動ビルドを動作
screen -S vite -X stuff ' \
    cd "$WORKDIR"; \
    npm run dev \
\n'

# queue セッションで Laravel のキューを動作
screen -S queue -X stuff ' \
    cd "$WORKDIR"; \
    php artisan queue:work \
\n'

# serve セッションで Laravel のサーバーを動作
screen -S serve -X stuff ' \
    cd "$WORKDIR"; \
    php artisan serve --host 0.0.0.0 --port 80 \
\n'

sleep infinity
