#!/bin/bash
# Generate secure passwords for Jitsi Meet
echo "JICOFO_AUTH_PASSWORD=$(openssl rand -hex 16)"
echo "JVB_AUTH_PASSWORD=$(openssl rand -hex 16)"
echo "JIGASI_XMPP_PASSWORD=$(openssl rand -hex 16)"
echo "JIBRI_RECORDER_PASSWORD=$(openssl rand -hex 16)"
echo "JIBRI_XMPP_PASSWORD=$(openssl rand -hex 16)"
echo "JICOFO_COMPONENT_SECRET=$(openssl rand -hex 16)"
