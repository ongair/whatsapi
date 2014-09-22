require "whatsapi/version"
module Whatsapi

	class Constants
		# Describes the connection status with the WhatsApp server.
		CONNECTED_STATUS = 'connected' 

		# Describes the connection status with the WhatsApp server.
		DISCONNECTED_STATUS = 'disconnected'

        # Port
        PORT = 433

        # The timeout for the connection with the WhatsApp servers.
        TIMEOUT_SEC = 2

        # The check credentials host.        
        WHATSAPP_CHECK_HOST = 'v.whatsapp.net/v2/exist'

        # The check credentials host.
        WHATSAPP_GROUP_SERVER = 'g.us'

        # Request host
        WHATSAPP_REQUEST_HOST = 'v.whatsapp.net/v2/code'

        # Whatsapp server
        WHATSAPP_SERVER = 's.whatsapp.net'

        # The upload host
        WHATSAPP_UPLOAD_HOST = 'https://mms.whatsapp.net/client/iphone/upload.php'

        # Device Name
        WHATSAPP_DEVICE = 'Android'

        # Version
        WHATSAPP_VER = '2.11.399'

        # User Agent
        WHATSAPP_USER_AGENT = 'WhatsApp/2.11.339 Android/4.3 Device/GalaxyS3'
	end
end