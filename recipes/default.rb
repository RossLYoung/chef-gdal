gdal_version = node['gdal']['version']
gdal_folder = node['gdal']['folder_version'] || gdal_version

tarball = "gdal-#{gdal_version}.tar"
tarball_gz = "gdal-#{gdal_version}.tar.gz"
gdal_url = node['gdal']['download_url'] || "http://download.osgeo.org/gdal/#{tarball_gz}"

remote_file "/tmp/#{tarball_gz}" do
  source gdal_url
  mode "0644"
  action :create_if_missing
end

bash "install_gdal_#{gdal_version}" do
  untar_dir = "/usr/local/src"
  user "root"
  code <<-EOH
    cd #{untar_dir} && \
    tar xzvf /tmp/#{tarball_gz} && \
    cd gdal-#{gdal_folder} && \
    ./configure && make && make install && \
    ldconfig
  EOH
  command ""
  not_if { ::File.exists? "/usr/local/bin/gdal-config" }
  action :run
end
