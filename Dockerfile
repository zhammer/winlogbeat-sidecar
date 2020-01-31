FROM mcr.microsoft.com/windows/servercore/iis:windowsservercore-ltsc2019

# 'filebeat' or 'winlogbeat'
ARG BEAT
# version of $BEAT
ARG VERSION

RUN powershell Invoke-WebRequest \"https://artifacts.elastic.co/downloads/beats/$env:BEAT/$env:BEAT-$env:VERSION-windows-x86_64.zip\" -UseBasicParsing -OutFile \"$env:BEAT.zip\" ; \
    Expand-Archive \"$env:BEAT.zip\" \"C:\Program Files\" ; \
    Rename-Item \"C:\Program Files\$env:BEAT-$env:VERSION-windows-x86_64\" \"C:\Program Files\$env:BEAT\" ; \
    Remove-Item \"$env:BEAT.zip\"

WORKDIR C:\\Program Files\\${BEAT}
