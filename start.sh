#!/bin/sh

clear

display_banner() {
    echo "******************************************************"
    echo "開発者: HacKun"
    echo "教育目的の使用をお願いします"
    echo "******************************************************"
}

stop_php_server() {
    echo "サーバーを停止しています..."
    kill "$php_server_pid" > /dev/null 2>&1
    kill "$tunnel_pid" > /dev/null 2>&1
    exit 0
}

get_tunnel_link() {
    echo "🔗 Localhost.run トンネルを作成中..."
    sleep 1

    # SSHトンネルの確立
    ssh -o ServerAliveInterval=60 -o ExitOnForwardFailure=yes -R 80:localhost:8080 nokey@localhost.run > .tunnel.log 2>&1 &
    tunnel_pid=$!

    sleep 3

    if grep -q "https://" ".tunnel.log"; then
        tunnel_url=$(grep -o 'https://[^ ]*\.lhr\.life' .tunnel.log)
        if [ -n "$tunnel_url" ]; then
            echo "発行URL: $tunnel_url"
        else
            echo "⚠️ URLが正しく取得できませんでした。ログを確認してください。"
        fi
    else
        echo "⚠️ Localhost.run のURLを取得できませんでした。ログを確認してください。"
        exit 1
    fi
}

trap stop_php_server SIGINT

display_banner

# 必要なパッケージのインストール（PHP、PHP-CURL、SSH）
echo "必要なパッケージをインストール中..."
sleep 1
apk update
sleep 1
apk add php81 php81-curl openssh httpd
sleep 1

# PHPローカルサーバーの起動
echo "PHPサーバーを起動中..."
sleep 1
php81 -S 0.0.0.0:8080 > /dev/null 2>&1 &
php_server_pid=$!

sleep 2

# Localhost.runトンネルの作成
get_tunnel_link

wait
