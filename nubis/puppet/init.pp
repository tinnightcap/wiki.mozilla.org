# Main entry for puppet
#
# import is depricated and we should use another method for including these
#+ manifests
#

import 'wikimo.pp'
import 'datadog.pp'
import 'apache.pp'
import 'fluentd.pp'
import 'varnish.pp'
import 'nubis_configuration.pp'
import 'nubis_storage.pp'
