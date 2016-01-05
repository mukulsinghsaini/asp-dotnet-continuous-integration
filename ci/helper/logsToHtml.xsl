<?xml version="1.0" ?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	>
	<xsl:template match="/logs">

	 <html>
		<head>
			<style>
					body {
					cursor: default;
					font-size: 14px;
					line-height: 21px;
					font-family: "Segoe UI","Helvetica",Garuda,Arial,sans-serif;
					padding: 18px 18px 18px 18px;
					}
					ul {
					margin-bottom: 14px;
					list-style: none;
					padding:0px;
					}
					li { width:100%; margin: 0 0 7px 0;float:left;background-color:#F7F5F5; }
					li span { 
					display: block;
					margin: 0 0 7px 0;
					font-size: 18px;
					color: #333;
					padding: 5px 0 0 20px;
					text-decoration: none;
					float:left;
					}

					li span:hover { background-color: #EFEFEF; }

					.harleen { border-left: 5px solid #F5876E; }

					.abhinav { border-left: 5px solid #61A8DC; }

					.ravinder { border-left: 5px solid #8EBD40; }

					.mukul { border-left: 5px solid #988CC3; }

					.gold { border-left: 5px solid #D8C86E; }
					
					.author {float:left;font-size:14px;font-weight:bold;width:80px;}
					
					.date {float:left;font-size:12px;width:100px;}
					
					.msg {float:left;font-size:14px;}
					
			</style>
			<script src="jquery.js"></script>
			<script src="moment.min.js"></script>
			
		</head>
      <body>
	  <div style="margin:0 auto;display:block;width:460px;">
		<pre style="font-weight:bolder;height:80px;">
 ___          _        _     ___ _            _         _   
| _ \_ _ ___ (_)___ __| |_  / __| |_  ___ _ _| |___  __| |__
|  _/ '_/ _ \| / -_) _|  _| \__ \ ' \/ -_) '_| / _ \/ _| / /
|_| |_| \___// \___\__|\__| |___/_||_\___|_| |_\___/\__|_\_\ 
           |__/                                             
		</pre>
		<p style="text-align:center;margin:0px;font-weight:bold;">continuous integration v1.0</p>
		<p style="text-align:center;margin:0px;font-weight:bold;">Abhinav,Harleen,Ravinder,Mukul</p>	
		</div>
		<p style="text-align:left;"><span style="padding-right:10px;font-weight:500;">Last Published:</span><span id="timestamp"> - </span></p>
       <ul>
		  <xsl:for-each select="/logs/logentry">
			<xsl:choose>
				<xsl:when test="not(msg='') and not(msg='\r\n')">
					<li class="{author}">
					<span>
						<div class="author">
						<xsl:value-of select="author" />
						</div>
						<div class="date">
						<xsl:value-of select="date" />
						</div>
						<div class="msg">
						<xsl:value-of select="msg" />
						</div>
					</span>
					</li>
				</xsl:when>
				<xsl:otherwise>
				</xsl:otherwise>
          </xsl:choose> 
		 </xsl:for-each>
		</ul>
		<script type="text/javascript">
	  $(function() {
		
		$.map($(".date"), function(dateDiv,i) {
				var $dateDiv = $(dateDiv);
				$dateDiv.html(moment($dateDiv.html()).fromNow());
		});
		
		$.get("updatedon.txt",function(data) {  $("#timestamp").html(data);  });
		
		});
	  </script>
      </body>
    </html>
	</xsl:template>
</xsl:stylesheet>
