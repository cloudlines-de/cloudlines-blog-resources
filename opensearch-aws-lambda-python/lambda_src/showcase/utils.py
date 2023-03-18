import boto3
import logging
import os
from opensearch_logger import OpenSearchHandler


def get_logger(log_level_str: str = None, name: str = None):
    """
    Takes either the log_level_str argument or if not specified uses the LOG_LEVEL environment variable
    and returns a logger instance. If both log_level_str and LOG_LEVEL are not provided,
    a default log level or WARNING will be used.

    :param log_level_str: log level as string, e.g. "WARNING"
    :param name: name of the logger, appearing as attribute log.logger in OpenSearch
    :return: logger instance
    """
    if log_level_str is None:
        log_level_str = os.getenv("LOG_LEVEL") or "WARNING"

    if name is None:
        name = __name__

    log_level = logging.getLevelName(log_level_str)
    logger = logging.getLogger(name)
    logger.setLevel(log_level)

    # get parameters and set up OpenSearch log handler, otherwise return the standard log handler above
    try:
        opensearch_params = _get_opensearch_ssm_parameters()
    except Exception as e:
        logger.error(f"could not fetch SSM parameters for OpenSearch connection: {e}")
        return logger

    handler = OpenSearchHandler(
        index_name=opensearch_params['opensearch-logging-index-name'],
        hosts=[opensearch_params['opensearch-logging-host']],
        http_auth=(
            opensearch_params['opensearch-logging-http-auth-user'],
            opensearch_params['opensearch-logging-http-auth-password']
        ),
        http_compress=True,
        use_ssl=True,
        verify_certs=False,
        ssl_assert_hostname=False,
        ssl_show_warn=False,
        # buffer_size needs to be 1, otherwise the lambda function might exit before the buffer is emptied
        # and messages will never be sent to OpenSearch
        buffer_size=1,
    )

    logger.addHandler(handler)
    return logger


def _get_opensearch_ssm_parameters() -> dict:
    """
    Retrieves OpenSearch connection parameters from SSM and returns them as a dict.
    In case not all parameters could be found (i.e. they were not created in SSM), an
    exception is thrown.

    :return: dict with connection parameters
    """
    ssm_client = boto3.client('ssm', region_name='eu-central-1')
    response = ssm_client.get_parameters(Names=[
        "opensearch-logging-http-auth-user",
        "opensearch-logging-http-auth-password",
        "opensearch-logging-host",
        "opensearch-logging-index-name"
    ], WithDecryption=True)

    if response['InvalidParameters']:
        raise Exception(f"unable to fetch SSM parameters: {response['InvalidParameters'].join(',')}")

    return {
        x['Name']: x['Value'] for x in response['Parameters']
    }
