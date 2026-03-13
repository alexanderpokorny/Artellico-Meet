#!/bin/sh
# Artellico Meet – Apply branding patches to interface_config.js
# Run after container start: docker exec artellico-meet-web-1 /branding/apply-branding.sh

CONFIG="/config/interface_config.js"

sed -i "s/APP_NAME: 'Jitsi Meet'/APP_NAME: 'Artellico Meet'/" "$CONFIG"
sed -i "s|JITSI_WATERMARK_LINK: 'https://jitsi.org'|JITSI_WATERMARK_LINK: 'https://www.artellico.com'|" "$CONFIG"
sed -i "s/MOBILE_APP_PROMO: true/MOBILE_APP_PROMO: false/" "$CONFIG"
sed -i "s/PROVIDER_NAME: 'Jitsi'/PROVIDER_NAME: 'Artellico'/" "$CONFIG"
sed -i "s|// DEFAULT_LOCAL_DISPLAY_NAME: 'me'|DEFAULT_LOCAL_DISPLAY_NAME: 'Ich'|" "$CONFIG"
sed -i "s|// DEFAULT_REMOTE_DISPLAY_NAME: 'Fellow Jitster'|DEFAULT_REMOTE_DISPLAY_NAME: 'Teilnehmer'|" "$CONFIG"
sed -i "s|// NATIVE_APP_NAME: 'Jitsi Meet'|NATIVE_APP_NAME: 'Artellico Meet'|" "$CONFIG"
sed -i "s|// NATIVE_APP_NAME: 'Artellico Meet'|NATIVE_APP_NAME: 'Artellico Meet'|" "$CONFIG"

# Append config.js overrides if not already present
CONFJS="/config/config.js"
if ! grep -q "defaultLanguage" "$CONFJS" 2>/dev/null; then
  printf '\nconfig.defaultLanguage = "de";\nconfig.disableThirdPartyRequests = true;\n' >> "$CONFJS"
fi

echo "[branding] Artellico branding applied"
