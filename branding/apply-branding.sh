#!/bin/sh
# Artellico Meet – Apply branding patches at container startup
# Mounted as /etc/cont-init.d/99-artellico-branding

# 1. Patch interface_config.js
CONFIG="/config/interface_config.js"
if [ -f "$CONFIG" ]; then
  sed -i "s/APP_NAME: 'Jitsi Meet'/APP_NAME: 'Artellico Meet'/" "$CONFIG"
  sed -i "s|JITSI_WATERMARK_LINK: 'https://jitsi.org'|JITSI_WATERMARK_LINK: 'https://www.artellico.com'|" "$CONFIG"
  sed -i "s/MOBILE_APP_PROMO: true/MOBILE_APP_PROMO: false/" "$CONFIG"
  sed -i "s/PROVIDER_NAME: 'Jitsi'/PROVIDER_NAME: 'Artellico'/" "$CONFIG"
  sed -i "s|DEFAULT_LOCAL_DISPLAY_NAME: 'me'|DEFAULT_LOCAL_DISPLAY_NAME: 'Ich'|" "$CONFIG"
  sed -i "s|DEFAULT_REMOTE_DISPLAY_NAME: 'Fellow Jitster'|DEFAULT_REMOTE_DISPLAY_NAME: 'Teilnehmer'|" "$CONFIG"
  sed -i "s|NATIVE_APP_NAME: 'Jitsi Meet'|NATIVE_APP_NAME: 'Artellico Meet'|" "$CONFIG"
fi

# 2. Patch config.js
CONFJS="/config/config.js"
if [ -f "$CONFJS" ]; then
  if ! grep -q "defaultLanguage" "$CONFJS" 2>/dev/null; then
    cat >> "$CONFJS" << 'CFGEOF'

// Artellico Meet – Custom Branding
config.defaultLanguage = "de";

// Watermark & Branding
config.dynamicBrandingUrl = "/static/branding.json";

// Disable Jitsi promotions
config.disableThirdPartyRequests = true;

// Custom names
config.subject = "Artellico Meet";
CFGEOF
  fi
fi

# 3. Create branding.json for dynamic branding
mkdir -p /config/nginx-custom
cat > /config/branding.json << 'BJEOF'
{
  "logoClickUrl": "https://artellico.com",
  "logoImageUrl": "/images/watermark.svg",
  "virtualBackgrounds": [],
  "inviteDomain": "meet.artellico.com"
}
BJEOF

# 4. Copy watermark to persistent config for nginx serving
cp /usr/share/jitsi-meet/images/watermark.svg /config/watermark.svg 2>/dev/null
chmod 644 /config/watermark.svg /config/branding.json

# 5. Create nginx custom config
cat > /config/nginx-custom/artellico-branding.conf << 'NGXEOF'
# Artellico branding - serve custom assets from persistent config
location = /images/watermark.svg {
    alias /config/watermark.svg;
    add_header Cache-Control "public, max-age=86400";
}

location = /static/branding.json {
    alias /config/branding.json;
    add_header Cache-Control "public, max-age=3600";
    add_header Content-Type "application/json";
}

# Block crawlers
location = /robots.txt {
    default_type text/plain;
    return 200 "User-agent: *\nDisallow: /\n";
}

# Block welcome page - only room URLs work
location = / {
    default_type text/html;
    return 200 '<!DOCTYPE html><html><head><meta charset="utf-8"><title>Artellico Meet</title><style>body{font-family:system-ui;display:flex;justify-content:center;align-items:center;height:100vh;margin:0;background:#1a1a2e;color:#e0e0e0}div{text-align:center}h1{font-size:2rem;margin-bottom:1rem}p{color:#888;font-size:1.1rem}</style></head><body><div><h1>Artellico Meet</h1><p>Meetings sind nur \u00fcber Terminbuchung verf\u00fcgbar.</p><p style="margin-top:2rem"><a href="https://artellico.com" style="color:#6c63ff;text-decoration:none">artellico.com</a></p></div></body></html>';
}
NGXEOF

echo "[branding] Artellico branding applied"
