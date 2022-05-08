#!/bin/sh

echo "setup keyboard layout"
read KEYLAYOUT
echo loadkeys $KEYLAYOUT
