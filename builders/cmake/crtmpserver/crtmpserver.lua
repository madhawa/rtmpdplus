configuration=
{
	daemon=false,
	-- daemon=true,
	pathSeparator="/",

	dnsResolver=
	{
		ip="127.0.0.1",
		port=9311,
		acceptors = 
		{
			{
				ip="0.0.0.0",
				port=9311,
				protocol="inboundDns"
			},	
		}
	},

	logAppenders=
	{
		{
			name="console appender",
			type="coloredConsole",
			level=6
		},
		{
			name="file appender",
			type="file",
			level=6,
			fileName="/tmp/rtmpserver2.log"
		}
	},
	
	applications=
	{
		rootDirectory="/usr/local/lib/crtmpserver/applications",
		{
			name="appselector",
			description="Application for selecting the rest of the applications",
			protocol="dynamiclinklibrary",
			validateHandshake=false,
			default=true,
			sharedKey="mykey",
			-- sharedKey="",
			acceptors = 
			{
				{
					ip="0.0.0.0",
					port=1935,
					protocol="inboundRtmp"
				},
				{
					ip="0.0.0.0",
					port=8081,
					protocol="inboundRtmps",
					sslKey="server.key",
					sslCert="server.crt"
				},
				{
					ip="0.0.0.0",
					port=8080,
					protocol="inboundRtmpt"
                		},

			}
		},
		
		{
			name="flvplayback",
			description="FLV Playback Sample",			
			protocol="dynamiclinklibrary",
			mediaFolder="/data/movies",
			-- sharedKey="mykey",
			-- sharedKey="",

			aliases=
			{
				"vod",
				"live",
			},
			acceptors = 
			{
				{
					ip="0.0.0.0",
					port=1935,
					protocol="inboundRtmfp"
				},
				{
					ip="0.0.0.0",
					port=6666,
					protocol="inboundLiveFlv",
					waitForMetadata=true,
				},
				{
					ip="0.0.0.0",
					port=9999,
					protocol="inboundTcpTs"
				},
				{
					ip="0.0.0.0",
					port=554,
					protocol="inboundRtsp"
				},
			},
			externalStreams = 
			{
				{
					uri="rtmp://111.111.28.131:90/live/pc1",
					localStreamName="livettv",
				},
			},
			validateHandshake=false,
			keyframeSeek=true,
			seekGranularity=1.5, --in seconds, between 0.1 and 600
			clientSideBuffer=12, --in seconds, between 5 and 30
		},
		
		{
			name="proxypublish",
			description="Application for forwarding streams to another RTMP server",
			protocol="dynamiclinklibrary",
			acceptors =
			{
				{	
					ip="0.0.0.0",
					port=6665,
					protocol="inboundLiveFlv"
				},
			},
			abortOnConnectError=true,
			targetServers = 
			{
				--[[{
					targetUri="rtmp://localhost/vod",
					targetStreamType="live", -- (live, record or append)
					emulateUserAgent="My user agent"
				},]]--
			},
			--[[externalStreams = 
			{
				{
					uri="rtmp://111.111.28.131:90/live/myStream",
					localStreamName="myStream"
                		},
			},]]--
		},
		--#INSERTION_MARKER# DO NOT REMOVE THIS. USED BY appscaffold SCRIPT.
	}
}