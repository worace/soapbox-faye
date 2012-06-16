module FayeConfig
  if ENV['RACK_ENV'] == 'development'
    ROOT_URL   = "http://localhost"
  else
    ROOT_URL   = "http://soapbox.im"
  end

  FAYE_TOKEN = "fayeforall"
  FAYE_PORT  = "9998"
  FAYE_URL   = ROOT_URL+":"+FAYE_PORT+"/faye"

  SERVICE_PORT_COMMENTS = "81"
  SERVICE_URL_COMMENTS  = ROOT_URL+":"+SERVICE_PORT_COMMENTS
end
