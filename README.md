# winlogbeat-sidecar

playground for trying to get a `winlogbeat` sidecar job to read event logs from an `app` container as a `filebeat` sidecar would read text logs.

current approach is to mount the app's `C:\Windows\System32\winevt\Logs` to a shared volume and have `winlogbeat` read from those `.evtx` files, but it seems that those files have a restrictive lock:
```
{"level":"warn","timestamp":"2020-01-30T17:24:18.342Z","caller":"beater/eventlogger.go:113","message":"EventLog[c:\\alloc\\data\\Application.evtx] Open() error. No events will be read from this source. failed to get handle to event log file c:\\alloc\\data\\Application.evtx: The process cannot access the file because it is being used by another process."}
{"level":"warn","timestamp":"2020-01-30T17:24:18.344Z","caller":"beater/eventlogger.go:113","message":"EventLog[c:\\alloc\\data\\System.evtx] Open() error. No events will be read from this source. failed to get handle to event log file c:\\alloc\\data\\System.evtx: The process cannot access the file because it is being used by another process."}
{"level":"warn","timestamp":"2020-01-30T17:24:18.344Z","caller":"beater/eventlogger.go:113","message":"EventLog[c:\\alloc\\data\\Security.evtx] Open() error. No events will be read from this source. failed to get handle to event log file c:\\alloc\\data\\Security.evtx: The process cannot access the file because it is being used by another process."}
```

interested in any approaches to make this work (if it's possible)!

# setup

run: `docker-compose up`

containers:
- `app`: powershell script that logs both to a log file and an event log on a loop
- `winlogbeat`: winlogbeat container that tries to read from mounted `evtx` event log files from `app`, outputs to console
- `filebeat`: example filebeat container that successfully reads from mounted `.log` file from `app`, outputs to console

# notes

this follows an [example in the winlogbeat FAQs](https://www.elastic.co/guide/en/beats/winlogbeat/current/reading-from-evtx.html) for reading from `.evtx`, though in that case winlogbeat reads from archived `.evtx` files, hence no lock conflict
