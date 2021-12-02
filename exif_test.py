from PIL import Image

image = Image.open('Planet9_3840x2160.jpg')

# next 3 lines strip exif
data = list(image.getdata())
image_without_exif = Image.new(image.mode, image.size)
image_without_exif.putdata(data)

image_without_exif.save('Planet9_3840x2160_without_exif.jpg')