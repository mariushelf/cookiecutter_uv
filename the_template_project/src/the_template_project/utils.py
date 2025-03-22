import logging

from the_template_project.settings import LogSettings


def setup_logging() -> None:
    """Set up the logging system."""
    log_config = LogSettings()
    logging.basicConfig(level=log_config.loglevel_3rdparty, **log_config.basicConfig)

    our_loglevel = log_config.loglevel
    for package in log_config.our_packages:
        logging.getLogger(package).setLevel(our_loglevel)
