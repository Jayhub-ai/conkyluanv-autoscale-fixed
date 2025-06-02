FROM ubuntu:24.04 AS builder

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive \
  apt-get install -qy --no-install-recommends --fix-missing \
  audacious-dev \
  ca-certificates \
  clang \
  cmake \
  curl \
  gfortran \
  git \
  gperf \
  libarchive-dev \
  libaudclient-dev \
  libc++-dev \
  libc++abi-dev \
  libcairo2-dev \
  libcurl4-openssl-dev \
  libdbus-glib-1-dev \
  libical-dev \
  libimlib2-dev \
  libircclient-dev \
  libiw-dev \
  libjsoncpp-dev \
  liblua5.3-dev \
  libmicrohttpd-dev \
  libmysqlclient-dev \
  libncurses-dev \
  libpulse-dev \
  librhash-dev \
  librsvg2-dev \
  libssl-dev \
  libsystemd-dev \
  libuv1-dev \
  libxdamage-dev \
  libxext-dev \
  libxft-dev \
  libxinerama-dev \
  libxml2-dev \
  ninja-build \
  patch \
  && apt-get -f install \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

COPY . /conky
WORKDIR /conky/build

ARG X11=yes

RUN sh -c 'if [ "$X11" = "yes" ] ; then \
  cmake -G Ninja \
  -DCMAKE_C_COMPILER=clang \
  -DCMAKE_CXX_COMPILER=clang++ \
  -DCMAKE_INSTALL_PREFIX=/opt/conky \
  -DBUILD_AUDACIOUS=ON \
  -DBUILD_HTTP=ON \
  -DBUILD_ICAL=ON \
  -DBUILD_ICONV=ON \
  -DBUILD_IRC=ON \
  -DBUILD_JOURNAL=ON \
  -DBUILD_LUA_CAIRO=ON \
  -DBUILD_LUA_CAIRO_XLIB=ON \
  -DBUILD_LUA_IMLIB2=ON \
  -DBUILD_LUA_RSVG=ON \
  -DBUILD_MYSQL=ON \
  -DBUILD_NVIDIA=OFF \
  -DBUILD_PULSEAUDIO=ON \
  -DBUILD_RSS=ON \
  -DBUILD_WAYLAND=OFF \
  -DBUILD_WLAN=ON \
  -DBUILD_XMMS2=OFF \
  ../ \
  ; else \
  cmake -G Ninja \
  -DCMAKE_C_COMPILER=clang \
  -DCMAKE_CXX_COMPILER=clang++ \
  -DCMAKE_INSTALL_PREFIX=/opt/conky \
  -DBUILD_AUDACIOUS=ON \
  -DBUILD_HTTP=ON \
  -DBUILD_ICAL=ON \
  -DBUILD_ICONV=ON \
  -DBUILD_IRC=ON \
  -DBUILD_JOURNAL=ON \
  -DBUILD_LUA_CAIRO=ON \
  -DBUILD_LUA_IMLIB2=ON \
  -DBUILD_LUA_RSVG=ON \
  -DBUILD_MYSQL=ON \
  -DBUILD_PULSEAUDIO=ON \
  -DBUILD_RSS=ON \
  -DBUILD_WAYLAND=OFF \
  -DBUILD_WLAN=ON \
  -DBUILD_X11=OFF \
  -DBUILD_XMMS2=OFF \
  -DBUILD_NVIDIA=OFF \
  ../ \
  ; fi' \
  && cmake --build . \
  && cmake --install .

FROM ubuntu:24.04

# Base packages that have consistent names across architectures
RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive \
  apt-get install -qy --no-install-recommends --fix-missing \
  bash \
  libaudclient2 \
  libc++1 \
  libc++abi1 \
  libcairo2 \
  libdbus-glib-1-2 \
  libircclient1 \
  liblua5.3-0 \
  libmysqlclient21 \
  libncurses6 \
  libpulse0 \
  librsvg2-2 \
  libsm6 \
  libsystemd0 \
  libxcb-xfixes0 \
  libxdamage1 \
  libxext6 \
  libxfixes3 \
  libxft2 \
  libxi6 \
  libxinerama1 \
  libxml2 \
  && apt-get -f install \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Handle architecture-specific package names with a script
RUN echo '#!/bin/bash\n\
# Try installing packages with their architecture-specific names first, \n\
# falling back to the generic name if not available\n\
function try_install() {\n\
  DEBIAN_FRONTEND=noninteractive apt-get install -qy --no-install-recommends --fix-missing "$1" 2>/dev/null || \n\
  DEBIAN_FRONTEND=noninteractive apt-get install -qy --no-install-recommends --fix-missing "$2"\n\
}\n\
\n\
try_install libcurl4t64 libcurl4\n\
try_install libical3t64 libical3\n\
try_install libimlib2t64 libimlib2\n\
try_install libiw30t64 libiw30\n\
try_install libmicrohttpd12t64 libmicrohttpd12\n\
\n\
apt-get clean\n\
rm -rf /var/lib/apt/lists/*\n\
' > /install-deps.sh \
  && chmod +x /install-deps.sh \
  && /install-deps.sh \
  && rm /install-deps.sh

COPY --from=builder /opt/conky /opt/conky

# Set PATH and LD_LIBRARY_PATH without referencing undefined variables
ENV PATH="/opt/conky/bin:${PATH}"
ENV LD_LIBRARY_PATH="/opt/conky/lib"

ENTRYPOINT [ "/opt/conky/bin/conky" ]
