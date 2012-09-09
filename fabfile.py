from fabric.api import env, lcd, local, task
import otto.blog as blog
from otto.util import paths

import logging
logging.basicConfig(level=logging.INFO)

env['otto.build_dir'] = 'build/staged'
#env['otto.template_dir'] = './templates'
env['otto.site'] = 'www.webquills.net'

@task
def B():
    """Set remote host to boadicea.octoped.net"""
    env.hosts.append('boadicea.octoped.net')

@task
def build():
    """Build the site"""
    target = env['otto.build_dir']
    with lcd(paths.local_workspace()):
        local('rm -rf build/*') # make clean
        local('mkdir -p %s' % target)
        local('cp -a etc %s/' % target)
        # local('cp -a content %s/htdocs' % target)
        blog.build_blog('content', 'htdocs')

@task
def clean():
    """Clean up build files."""
    with lcd(paths.local_workspace()):
        local('rm -rf build/*')
