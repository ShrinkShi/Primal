@echo off
setlocal

set "APP_HOME=%~dp0"
set "WRAPPER_JAR=%APP_HOME%gradle\wrapper\gradle-wrapper.jar"
set "WRAPPER_URL=https://raw.githubusercontent.com/NeoForgeMDKs/MDK-1.21.1-ModDevGradle/30cafee9cd8d7f46427ec88fa8579d49c146df9a/gradle/wrapper/gradle-wrapper.jar"

if not exist "%WRAPPER_JAR%" (
    echo [Primal] gradle-wrapper.jar 不存在，正在从固定的 NeoForge 1.21.1 MDK 提交下载官方 Wrapper...
    if not exist "%APP_HOME%gradle\wrapper" mkdir "%APP_HOME%gradle\wrapper"
    powershell -NoProfile -ExecutionPolicy Bypass -Command "$ProgressPreference='SilentlyContinue'; Invoke-WebRequest -UseBasicParsing '%WRAPPER_URL%' -OutFile '%WRAPPER_JAR%'"
    if errorlevel 1 (
        echo 下载 Gradle Wrapper JAR 失败。
        exit /b 1
    )
)

if defined JAVA_HOME (
    set "JAVACMD=%JAVA_HOME%\bin\java.exe"
) else (
    set "JAVACMD=java.exe"
)

"%JAVACMD%" -Dorg.gradle.appname=gradlew -jar "%WRAPPER_JAR%" %*
exit /b %ERRORLEVEL%
