package com.farm.wda.adaptor;

import java.io.File;

import com.farm.wda.domain.DocTask;
import com.farm.wda.util.AppConfig;
import com.farm.wda.wcpservice.WcpFileIndexServer;

public abstract class DocConvertorBase {
	// private static final Logger log =
	// Logger.getLogger(DocConvertorBase.class);
	public void convert(File file, String fileTypeName, File targetFile, DocTask task) {
		run(file, fileTypeName, targetFile);
		// 每次转换都会调用在wcp端生成索引的接口
		if (AppConfig.getString("config.callback.runLuceneIndex.start").toUpperCase().equals("TRUE")) {
			WcpFileIndexServer.runWcpFileIndex(task);
		}
	}

	public abstract void run(File file, String fileTypeName, File targetFile);
}
