# Define how apache should be installed and configured. This uses the
# puppetlabs-apache puppet module [0].
#
# [0] https://github.com/puppetlabs/puppetlabs-apache
#

class {
    'apache':
        default_mods        => true,
        default_vhost       => false,
        default_confd_files => false,
        mpm_module          => 'prefork';
    'apache::mod::status':;
    'apache::mod::php':;
    'apache::mod::remoteip':
        proxy_ips => [ '127.0.0.1', '10.0.0.0/8' ];
}

apache::vhost { $::project_name:
    port              => '8080',
    default_vhost     => true,
    docroot           => "/var/www/${::project_name}",
    docroot_owner     => 'ubuntu',
    docroot_group     => 'ubuntu',
    block             => ['scm'],
    setenvif          => 'X-Forwarded-Proto https HTTPS=on',
    access_log_format => '%a %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-agent}i\"',
    custom_fragment   => 'AddType image/svg+xml .svg',
    directories => [
        { path            => '%{DOCUMENT_ROOT}',
          provider        => 'directory',
          options         => ['FollowSymLinks'],
          allow_override  => ['None']
        },
        { path            => 'favicon.ico',
          provider        => 'files',
          custom_fragment => 'ForceType image/png'
        },
    ],
    rewrites => [
        {
            comment      => 'Rewrite the old UseMod URLs to the new MediaWiki ones',
            rewrite_rule => ['^/AdminWiki(/.*|$) https://intranet.mozilla.org/%{QUERY_STRING} [R=permanent,L]',
                             '^/PluginFutures(/.*|$) https://intranet.mozilla.org/PluginFutures$1 [R=permanent,L]'
            ],
        },
        {
            comment      => 'This is for the ECMAScript 4 working group, bug 324452',
            rewrite_rule => ['^/ECMA(/.*|$) https://intranet.mozilla.org/ECMA$1 [R=permanent,L]'
            ],
        },
        {
            comment      => 'Old Wikis that have been moved into the public wiki',
            rewrite_rule => ['^/Mozilla2\.0([/\?].*|$) /core/Mozilla2:Home_Page? [R,L]',
                             '^/GeckoDev([/\?].*|$) /core/GeckoDev:Home_Page? [R,L]',
                             '^/XULDev([/\?].*|$) /core/XUL:Home_Page? [R,L]',
                             '^/Calendar([/\?].*|$) /core/Calendar:Home_Page? [R,L]',
                             '^/DocShell([/\?].*|$) /core/DocShell:Home_Page? [R,L]',
                             '^/SVG([/\?].*|$) /core/SVG:Home_Page? [R,L]',
                             '^/SVGDev([/\?].*|$) /core/SVGDev:Home_Page? [R,L]',
                             '^/mozwiki https://%{SERVER_NAME}/ [R,L]'
            ],
        },
        {
            comment      => 'The following rules are only for backwards compatibility',
            rewrite_rule => ['^/wiki/(.*)$ http://%{SERVER_NAME}/$1 [R,L]',
                             '^/wiki$ http://%{SERVER_NAME}/index.php [R,L]'
            ],
        },
        {
            comment      => 'Dont rewrite requests for files in MediaWiki subdirectories',
            rewrite_cond => ['%{REQUEST_URI} !^/(extensions|images|skins|resources|vendor)/',
                             '%{REQUEST_URI} !^/(redirect|index|opensearch_desc|api|load|thumb).php',
                             '%{REQUEST_URI} !^/error/(40(1|3|4)|500).html',
                             '%{REQUEST_URI} !=/favicon.ico',
                             '%{REQUEST_URI} !^/robots.txt'
            ],
            rewrite_rule => ['^/(.*$) %{DOCUMENT_ROOT}/index.php [L]'
            ],
        },
    ],
}
