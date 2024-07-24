# Dockerfile

# 基础镜像
FROM elixir:latest

# 安装依赖
RUN apt-get update && \
    apt-get install -y npm

# 设置工作目录
WORKDIR /app

# 拷贝项目文件到工作目录
COPY . .

RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get && \
    mix assets.setup && \
    mix assets.build

RUN mix compile

CMD ["sh", "-c", "elixir --name \"$MY_APP_NODE@$(hostname -i)\" --cookie $ERLANG_COOKIE -S mix phx.server"]
