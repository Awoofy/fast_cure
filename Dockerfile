FROM ubuntu:22.04

# 環境変数の設定
ENV DEBIAN_FRONTEND=noninteractive
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV FLUTTER_HOME=/flutter
ENV FLUTTER_VERSION=3.29.0
ENV FLUTTER_COMMIT=35c388afb5
ENV PATH=$FLUTTER_HOME/bin:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$PATH

# 必要なパッケージのインストール
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    openjdk-11-jdk \
    wget \
    file \
    cmake \
    ninja-build \
    clang \
    pkg-config \
    libgtk-3-dev \
    && rm -rf /var/lib/apt/lists/*

# Android SDKのインストール
RUN mkdir -p ${ANDROID_SDK_ROOT} && \
    cd ${ANDROID_SDK_ROOT} && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip && \
    unzip commandlinetools-linux-*_latest.zip && \
    rm commandlinetools-linux-*_latest.zip && \
    mkdir -p cmdline-tools/latest && \
    mv cmdline-tools/* cmdline-tools/latest/ 2>/dev/null || true && \
    yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.0"

# Flutterのインストール（指定されたコミットハッシュを使用）
RUN git clone https://github.com/flutter/flutter.git $FLUTTER_HOME && \
    cd $FLUTTER_HOME && \
    git fetch && \
    git checkout ${FLUTTER_COMMIT} && \
    ./bin/flutter precache

# Flutter doctorの実行とライセンス同意
RUN yes | flutter doctor --android-licenses || true && \
    flutter doctor

# 作業ディレクトリの設定
WORKDIR /workspace

# ポート開放（Flutter開発サーバー用）
EXPOSE 8080