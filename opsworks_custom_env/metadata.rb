maintainer "timdorr"
description "Writes a config/application.yml file with custom ENV values to apps' deploy directories."
version "11.0.0"

recipe "opsworks_custom_env::configure", "Write a config/application.yml file to app's deploy directory. Relies on restart command declared by rails::configure recipe. (Intended as part of configure/deploy OpsWorks events.)"