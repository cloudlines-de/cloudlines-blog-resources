from utils import get_logger

# initialize outside of lambda_handler to save billing time
logger = get_logger(name="my_lambda_function")


def lambda_handler(event, context):
    logger.info("hello world from lambda", extra={
        "event": event,
        "aws.requestId": context.aws_request_id,
    })
