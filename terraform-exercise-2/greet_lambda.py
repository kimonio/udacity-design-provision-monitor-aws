import os

def lambda_handler(event, context):
    message = "{} from Lambda!".format(os.environ['greeting'])
    print(message) 
    return message
