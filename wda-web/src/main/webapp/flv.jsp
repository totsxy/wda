<%@page import="com.farm.wda.inter.WdaAppInter"%>
<%@page import="com.farm.wda.util.AppConfig"%>
<%@page import="java.io.File"%>
<%@page import="com.farm.wda.Beanfactory"%>
<%@ page language="java" pageEncoding="utf-8"%>
<html lang="zh-CN">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title><%=AppConfig.getString("config.web.title")%></title>
<link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<%
	WdaAppInter wad = Beanfactory.getWdaAppImpl();
%>
<body style="background-color: #8a8a8a;">
	<jsp:include page="/commons/head.jsp"></jsp:include>
	<div class="container">
		<div class="row">
			<div class="col-md-3"></div>
			<div class="col-md-6">
				<div class="panel panel-default">
					<div class="panel-heading">视频预览</div>
					<div class="panel-body" style="text-align: center;">
					
						<object type="application/x-shockwave-flash" 
							data="commons/player_maxi/player_flv_maxi.swf" width="320"
							height="240">
							<param name="movie"
								value="player_flv_maxi.swf" />
							<param name="allowFullScreen" value="true" />
							<param name="FlashVars"
								value="flv=../../<%=wad.getUrl(request.getParameter("key"), "FLV")%>&amp;width=320&amp;height=240&amp;showtime=1&amp;srt=1&amp;skin=skin.jpg&amp;margin=10&amp;startimage=commons/player_maxi/rorobong.jpg&amp;playercolor=cccccc&amp;buttoncolor=333333&amp;buttonovercolor=999999&amp;slidercolor1=333333&amp;slidercolor2=0&amp;sliderovercolor=999999&amp;loadingcolor=0&amp;showfullscreen=1" />
							<p>视频预览</p>
						</object>
					</div>
				</div>
			</div>
			<div class="col-md-3"></div>
		</div>
	</div>
</body>
</html>