require 'net/smtp'

message = <<MESSAGE_END
From: Bob <bob@example.com>
To: Alice <alice@example.com>
Subject: Internal Mail-Relay Test

This is a test e-mail message from your smtp gateway. Thanks for using our service.
MESSAGE_END

Net::SMTP.start('smtp.example.com') do |smtp|
  smtp.send_message message, 'bob@example.com', 'alice@example.com'
end
