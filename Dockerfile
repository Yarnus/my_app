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

# 安装依赖
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get && \
    mix assets.setup && \
    mix assets.build
# npm install --prefix assets

# 编译项目
RUN mix compile

# 运行 Phoenix 项目
CMD mix phx.server