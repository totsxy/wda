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
	String paht = request.getParameter("path");
	String key = request.getParameter("key");
	String typename = request.getParameter("typename");
	String filename = request.getParameter("filename");
	String txt = null;
	if ("NONE".equals(typename)) {
		typename = null;
	}
	if (key == null || key.isEmpty()) {
		key = "none";
	}
	if (filename == null || filename.isEmpty()) {
		filename = key;
	}
	WdaAppInter wad = Beanfactory.getWdaAppImpl();
	boolean isError=wad.getLogText(key)==null?false:wad.getLogText(key).indexOf("error")>0;
	if (AppConfig.getString("config.web.submit").equals("true")) {
		if (paht != null && key != null && typename != null && !paht.isEmpty() && !key.isEmpty()
				&& !typename.isEmpty()) {
			wad.generateDoc(key, new File(paht), typename, filename, "none");
		} else {
			if (paht != null && key != null && !paht.isEmpty() && !key.isEmpty()) {
				wad.generateDoc(key, new File(paht), filename, "none");
			}
		}
	}
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
					<div class="panel-body">
						<table class="table">
						<tr>
								<td style="text-align: center;">
									<!-- ----各种文件预览图标生成--开始--------------------------------------------------------------------- -->
									<%
										boolean isHaveFile = false;
										if (wad.isGenerated(key, "TXT")) {
											isHaveFile = true;
											if (curentUrl != null) {
												isOnlyOne = false;
											} else {
												curentUrl = wad.getUrl(key, "TXT");
												isOnlyOne = true;
											}
									%> <a href="<%=wad.getUrl(key, "TXT")%>"><img alt="TXT"
										src="img/txt.png"></a> <%
									 	}
									 %> <%
									 	if (wad.isGenerated(key, "HTML")) {
									 		isHaveFile = true;
									 		if (curentUrl != null) {
									 			isOnlyOne = false;
									 		} else {
									 			curentUrl = wad.getUrl(key, "HTML");
									 			isOnlyOne = true;
									 		}
									 %> <a href="<%=wad.getUrl(key, "HTML")%>"><img alt="HTML"
										src="img/html.png"></a> <%
									 	}
									 %> <%
									 	if (wad.isGenerated(key, "FLV")) {
									 		isHaveFile = true;
									 		if (curentUrl != null) {
									 			isOnlyOne = false;
									 		} else {
									 			curentUrl = "flv.jsp?key=" + key;
									 			isOnlyOne = true;
									 		}
									 %> <a href="flv.jsp?key=<%=key%>"><img alt="HTML"
										src="img/flv.png"></a> <%
																			}
																		%> <%
									 	if (wad.isGenerated(key, "PDF")) {
									 		isHaveFile = true;
									 		if (curentUrl != null) {
									 			isOnlyOne = false;
									 		} else {
									 			curentUrl = wad.getUrl(key, "PDF");
									 			isOnlyOne = true;
									 		}
									 %> <a href="<%=wad.getUrl(key, "PDF")%>"><img alt="PDF"
										src="img/pdf.png"></a> <%
									 	}
									 %> <%
									 	if (isHaveFile && wad.isLoged(key)) {
									 %>
									<div style="text-align: center; color: #f15a24;">点击图标预览文件</div>
									<%
										}
									%> <%
									 	if (!isHaveFile && wad.isLoged(key)) {
									 %>
									<div style="text-align:center; color: #f15a24;">
										<img alt="Brand" src="img/type.png">
									</div> <%
										}
									%><!-- ----各种文件预览图标生成--结束--------------------------------------------------------------------- -->
									<%if(!isError){%>	
										<%
										 	if (!isHaveFile && wad.isLoged(key)) {
										 %>
										 <center> 文件正在处理中，请稍后...</center>
										 <div class="progress">
										  <div class="progress-bar progress-bar-striped active" role="progressbar" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100" style="width: 100%">
										  </div>
										</div>
										<%
											}
										%>
									<% }%>
								</td>
							</tr>
							
							<tr>
								<td style="word-break: break-all;">
									<%
										try {
											txt = wad.getText(key);
										} catch (Exception e) {
											txt = e.getMessage();
										}
										if (txt == null) {
											txt = "";//暂无法获取文本信息
										}
										if (txt.length() > 200) {
											txt = txt.substring(0, 180) + "...";
										}
									%> <%=txt%> <%
 	if (wad.isLoged(key)) {
 %> <a href="<%=wad.getlogURL(key)%>">日志文件<!-- <img alt="日志文件"
										src="img/log.png"> --></a>
 <a href="clearDir.jsp?key=<%=key%>" title="用于重新构建预览" >清空</a> <%
 	} else {
 %><%
 	}
 %>
								</td>
							</tr>
							<%
								if (paht != null && !paht.isEmpty()) {
							%>
							<tr>
								<td><%=paht%></td>
							</tr>
							<%
								}
							%>
						</table>
					</div>
					<div class="panel-heading">
						<%
						 	if (wad.isLoged(key)&&isError) {
						 %>
						<div style="text-align: left; color: #f15a24;">
							<%=wad.getLogText(key) %>
						</div>
						<%
							}
						%>
					</div>
				</div>
			</div>
			<div class="col-md-3"></div>
		</div>
	</div>
	<script src="js/jquery11.3.js"></script>
	<script src="js/bootstrap.min.js"></script>
	<script type="text/javascript">
	<!--
	<%
	if(isOnlyOne){
		%>
		window.location ="<%=curentUrl %>";
		<%
	}
	if(!isHaveFile&&!isError){
		%>
		 window.setTimeout(function(){
			 location.reload();
		 },3000); 
		<%
	}
	%>
	//-->
	</script>
</body>
</html>