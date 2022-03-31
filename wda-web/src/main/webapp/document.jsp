<%@page import="java.util.Map"%>
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
<style>
<!--
td {
	max-width: 200px;
	font-size: 12px;
	word-wrap: break-word;
}

.mini {
	max-width: 200px;
	font-size: 8px;
	word-wrap: break-word;
}
-->
</style>
<body style="background-color: #8a8a8a;">
	<jsp:include page="/commons/head.jsp"></jsp:include>
	<div class="container">
		<div class="row">
			<div class="col-md-12">
				<div class="panel panel-default">
					<div class="panel-body text-center">
						<img alt="type" style="margin: auto;" class="img-responsive"
							src="img/type.png">
					</div>
				</div>
				<div class="panel panel-default">
					<div class="panel-heading">配置信息</div>
					<div class="panel-body">
						<div class="row">
							<div class="col-md-12">
								config.index=<%=AppConfig.getString("config.index")%><br />
								config.web.submit=<%=AppConfig.getString("config.web.submit")%><br />
								config.openoffice.port=<%=AppConfig.getString("config.openoffice.port")%><br />
								config.rmi.port=<%=AppConfig.getString("config.rmi.port")%><br />
								config.file.dir.path=<%=AppConfig.getString("config.file.dir.path")%><br />
								config.web.title=<%=AppConfig.getString("config.web.title")%><br />
								config.server.openoffice.cmd=<%=AppConfig.getString("config.server.openoffice.cmd")%><br />
								config.callback.runLuceneIndex.start=<%=AppConfig.getString("config.callback.runLuceneIndex.start")%><br />
								config.callback.runLuceneIndex.url=<%=AppConfig.getString("config.callback.runLuceneIndex.url")%><br />
							</div>
						</div>
					</div>
					<div class="panel-heading">当前服务状态</div>
					<div class="panel-body">
						<div class="row">
							<div class="col-md-12">
								openoffice服务状态(是否启动)：<%=Beanfactory.isStartByOpenofficeServer() %>
							</div>
						</div>
					</div>
					<div class="panel-heading">任务队列信息</div>
					<div class="panel-body">
						<div class="row">
							<div class="col-md-12">
								<table class="table table-bordered">
									<tr>
										<th>信息</th>
										<th>类型转换</th>
										<th>key</th>
										<th>目标路径</th>
										<th>状态</th>
										<th>入队时间</th>
										<th>转换开始时间</th>
									</tr>
									<%
										for (Map node : wad.getTasksinfo()) {
									%>
									<tr>
										<td><%=node.get("INFO")%></td>
										<td><%=node.get("TYPENAME")%> <b>to</b> <%=node.get("TARGETTYPE")%></td>
										<td class="mini"><%=node.get("AUTHID")%></td>
										<td class="mini"><%=node.get("PATH")%></td>
										<td><%=node.get("STATE")%></td>
										<td><%=node.get("CTIME")%></td>
										<td><%=node.get("STIME")%></td>
									</tr>
									<%
										}
									%><tr>
										<th colspan="8">任务 数量：<%=wad.getTasksinfo().size()%></th>
									</tr>
								</table>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>