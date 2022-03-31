package com.farm.wda.wcpservice;

import java.rmi.Naming;
import java.util.HashSet;
import java.util.Set;

import org.apache.log4j.Logger;

import com.farm.wcp.api.WcpAppInter;
import com.farm.wda.Beanfactory;
import com.farm.wda.domain.DocTask;
import com.farm.wda.util.AppConfig;

public class WcpFileIndexServer {
	/**
	 * 记录当前已经在wcp中做过索引的附件,超过100的队列长度就被清空
	 */
	private static Set<String> overIndexKeys = new HashSet<String>();
	private static final Logger log = Logger.getLogger(WcpFileIndexServer.class);

	/**
	 * 执行wcp的附件索引接口
	 * 
	 * @param task
	 */
	public static void runWcpFileIndex(DocTask task) {
		try {
			WcpAppInter wcpApp = (WcpAppInter) Naming.lookup(AppConfig.getString("config.callback.runLuceneIndex.url"));
			String text = Beanfactory.getWdaAppImpl().getText(task.getKey());
			if (text != null) {
				if (overIndexKeys.size() > 100) {
					// 超过100的队列长度就被清空
					overIndexKeys.clear();
				}
				if (overIndexKeys.contains(task.getKey())) {
					// 已经做过索引
				} else {
					// 未做过索引
					log.info("WDA调用WCP接口实现-----附件索引");
					wcpApp.runLuceneIndex(task.getKey(), task.getAuthid(), text);
					overIndexKeys.add(task.getKey());
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			log.error("wcp索引任务回调失败：" + e.getMessage() + e.toString());
		}
	}
}
