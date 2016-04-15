#
# Copyright 2012-2015 Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

name "binutils"
default_version "2.26"

version("2.26") { source sha256: "9615feddaeedc214d1a1ecd77b6697449c952eab69d79ab2125ea050e944bcc1" }

source url: "https://ftp.gnu.org/gnu/binutils/binutils-#{version}.tar.gz"

dependency "config_guess"

relative_path "binutils-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  update_config_guess

  if solaris_10?
    env['AR'] = '/usr/sfw/i386-sun-solaris2.10/bin/ar'
    patch source: "binutils-solaris-hwcap.patch"
  end

  configure_command = ["./configure",
                       "--without-nls",
                       "--prefix=#{install_dir}/embedded"]

  command configure_command.join(" "), env: env

  make "-j #{workers}", env: env
  make "-j #{workers} install", env: env
end
