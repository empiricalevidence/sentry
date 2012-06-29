Install
=======

    sudo ./install.sh
    workon sentry
    ./post-install.sh


New project on Sentry
=====================

We must create a new project in Sentry where we want to store our logging messages.
We go to Sentry url on port 9000 (Ex. http://localhost:9000) and do login with superuser.
In the user options is an option called "projects", we click on it. Now we click
on the "Create new project" button. The following steps are simple.
When we finished, we go into the admin panel of our new project.
The first thing you see will be the url where we can send our messages from our application.
If you need help to setting your application,
you can visit the different faqs for different platforms.


Sentry on Django
================

To start sending events from Django to Sentry we must install raven first

    pip install raven

And later modify Django configuration (settings.py)

    # Set your DSN value
    SENTRY_DSN = '<sentry-dns>'
    
    # Add raven to the list of installed apps
    INSTALLED_APPS = INSTALLED_APPS + (
    # ...
    'raven.contrib.django',
    )

    # You’ll be referencing the client slightly differently in Django as well
    from raven.contrib.django.models import client
    client.captureException()

    # To integrate with the standard library’s logging module.
    MIN_LOG_LEVEL_TO_DISPLAY = 'DEBUG' if DEBUG else 'WARNING'

    LOGGING = {
        'version': 1,
        'disable_existing_loggers': False,
        'filters': {
            'require_debug_false': {
                '()': 'django.utils.log.RequireDebugFalse'
            }
        },
        'handlers': {
            'console': {
                'level': MIN_LOG_LEVEL_TO_DISPLAY,
                'class': 'logging.StreamHandler',
            },
            'mail_admins': {
                'level': 'ERROR',
                'filters': ['require_debug_false'],
                'class': 'django.utils.log.AdminEmailHandler',
                'include_html': True,
            },
            'sentry': {
                'level': MIN_LOG_LEVEL_TO_DISPLAY,
                'class': 'raven.contrib.django.handlers.SentryHandler',
            },
        },
        'loggers': {
            'django': {
                'handlers': ['console', 'sentry'],
                'level': MIN_LOG_LEVEL_TO_DISPLAY,
                'propagate': False,
            },
            'django.request': {
                'handlers': ['console', 'sentry'],
                'level': MIN_LOG_LEVEL_TO_DISPLAY,
                'propagate': False,
            },
            'django.db.backends': {
                'handlers': ['console'],
                'level': MIN_LOG_LEVEL_TO_DISPLAY,
                'propagate': True,
            },
            'root': {
                'handlers': ['console', 'sentry'],
                'level': MIN_LOG_LEVEL_TO_DISPLAY,
                'propagate': True,
            },
            'raven': {
                'handlers': ['console'],
                'level': MIN_LOG_LEVEL_TO_DISPLAY,
                'propagate': True,
            },
            'sentry.errors': {
                'handlers': ['console'],
                'level': MIN_LOG_LEVEL_TO_DISPLAY,
                'propagate': True,
            },
        }
    }
