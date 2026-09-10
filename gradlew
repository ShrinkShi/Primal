#!/bin/sh
set -eu

APP_HOME=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
WRAPPER_JAR="$APP_HOME/gradle/wrapper/gradle-wrapper.jar"
WRAPPER_URL="https://raw.githubusercontent.com/NeoForgeMDKs/MDK-1.21.1-ModDevGradle/30cafee9cd8d7f46427ec88fa8579d49c146df9a/gradle/wrapper/gradle-wrapper.jar"

if [ ! -f "$WRAPPER_JAR" ]; then
    echo "[Primal] gradle-wrapper.jar 不存在，正在从固定的 NeoForge 1.21.1 MDK 提交下载官方 Wrapper..."
    mkdir -p "$(dirname "$WRAPPER_JAR")"
    if command -v curl >/dev/null 2>&1; then
        curl -fL "$WRAPPER_URL" -o "$WRAPPER_JAR"
    elif command -v wget >/dev/null 2>&1; then
        wget -O "$WRAPPER_JAR" "$WRAPPER_URL"
    else
        echo "需要 curl 或 wget 下载 Gradle Wrapper JAR。" >&2
        exit 1
    fi
fi

if [ -n "${JAVA_HOME:-}" ]; then
    JAVACMD="$JAVA_HOME/bin/java"
else
    JAVACMD="java"
fi

exec "$JAVACMD" -Dorg.gradle.appname=gradlew -jar "$WRAPPER_JAR" "$@"
