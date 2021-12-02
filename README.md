#  AWS/Terraform/Python Test 2021

AWS Lambda function written in Python 3.8 that will remove exif metadata from JPEG files when uploaded to S3.

Boto3 is the name of the Python SDK for AWS. It allows you to directly create, update, and delete AWS resources from your Python scripts.
The Python Imaging Library adds image processing capabilities to your Python interpreter. This library provides extensive file format support.

Test Case:

I have done a simple test using Python script below to see, compare with and without metadata and evidently we can see it saved lots of space :-)
And infact tested one resource code block for aws_iam_role taken directly from terraform.io document which works smoothly.

$ cat exif_test.py
from PIL import Image
image = Image.open('Planet9_3840x2160.jpg')
data = list(image.getdata())
image_without_exif = Image.new(image.mode, image.size)
image_without_exif.putdata(data)
image_without_exif.save('Planet9_3840x2160_without_exif.jpg')


-rw-r--r-- 1 User 197121 4099991 May 27  2020 Planet9_3840x2160.jpg
$ du -sh Planet9_3840x2160.jpg
4.0M    Planet9_3840x2160.jpg

-rw-r--r-- 1 User 197121  406320 Nov 29 21:24 Planet9_3840x2160_without_exif.jpg
$ du -sh Planet9_3840x2160_without_exif.jpg
400K    Planet9_3840x2160_without_exif.jpg

Deployment :

Make sure we have below software/libs

terraform 0.15+
python 3.8
- any other environments like pipenv if needed

Resources:
1. Two Users - UserA ( read/write access ) and UserB ( read access ) -> users.tf
2. S3 Buckets - gtestbucketa and gtestbucketb -> s3.tf. Note versioning and lifecycle rules (90 days) added to further enchance and we can even extend functionality to encrption for any audit exceptions or regulatory reasons.
3. Providers - required version "<= 1.0.1" -> providers.tf
4. main code - lambda.tf -> This will deploy the following resouces 
a) aws_iam_role with AssumeRole on the Principal lambda.amazonaws.com
b) aws_iam_policy attached with requiremed permission on s3 buckets resource
c) aws_iam_role_policy_attachment to both role and policy above
d) aws_lambda_function that has the compressed source file "uploadtobucket.zip" which contains the lambda function name
e) aws_lambda_function has the aws_iam_role defined
f) aws_s3_bucket_notification that has enabled trigger on the bucket a ie., gtestbucketa for all the events when the object gets created
e) additionaly, the bucket notification has depends_on condition which checks the permissions on s3 bucket as and when invokes necessarily to avoid unnecessary exceptions
5. python script that strips from any exif metadata on the files being shown on their website 

