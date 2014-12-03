Create a blog channel.

Channel = directory

channel.json = {
    'title': 'My Blog',
    'description': 'Greatest blog on the planet.',
    'author': {
        'name': 'Vince',
        'email':'vince@webquills.net',
        'url':'http://vince.veselosky.me',
        },
    'copyright': 'by me',
    'ttl': 60,
    'image': 'http://example.com/logo.gif',
    }

Entries...

Entry is any file within the channel directory that is tracked by git and has
an extension matching an accepted input format. For the first iteration, the
only accepted input format will be markdown. More to come soon.

When an entry is checked in:

    * Copy to build directory.
    * Compile it in memory. Store entry.json to build directory.
    * Render template. Store entry.html to build directory.
    * Add entry metadata to index.json in build directory.
    * Render template for index. Store index.html to build directory.
    * Render template for feed. Store feed to build directory.
    * TODO: Date-based archive.
    * TODO: Category archive.
