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
	boolean isOnlyOne = false;
	String curentUrl = null;
	String key = request.getParameter("key");
	WdaAppInter wad = Beanfactory.getWdaAppImpl();
	wad.clearDir(key);
%>
<body style="background-color: #8a8a8a;">
	<jsp:include page="/commons/head.jsp"></jsp:include>
	<div class="container">
		<div class="row">
			<div class="col-md-3"></div>
			<div class="col-md-6">
				<div class="panel panel-default">
					<div class="panel-body text-center">
						<%=wad.getInfo(key)%>
					</div>
				</div>
				<div class="panel panel-default">
					<div class="panel-heading">文档状态</div>
					<div class="panel-body"></div>
					<div class="panel-heading"></div>
				</div>
			</div>
			<div class="col-md-3"></div>
		</div>
	</div>
	<script src="js/jquery11.3.js"></script>
	<script src="js/bootstrap.min.js"></script>
	<script type="text/javascript">
		window.location ="path.jsp?key=<%=key%>";
	</script>
</body>
</html>