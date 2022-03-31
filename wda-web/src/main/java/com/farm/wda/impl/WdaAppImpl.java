package com.farm.wda.impl;

import java.io.File;
import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Queue;
import java.util.Set;

import org.apache.log4j.Logger;
import org.apache.lucene.document.Field.Index;
import org.apache.lucene.document.Field.Store;

import com.farm.wda.Beanfactory;
import com.farm.wda.domain.DocTask;
import com.farm.wda.exception.ErrorTypeException;
import com.farm.wda.inter.WdaAppInter;
import com.farm.wda.lucene.FarmLuceneFace;
import com.farm.wda.lucene.adapter.DocMap;
import com.farm.wda.lucene.server.DocIndexInter;
import com.farm.wda.util.AppConfig;
import com.farm.wda.util.ConfUtils;
import com.farm.wda.util.FileUtil;

public class WdaAppImpl extends UnicastRemoteObject implements WdaAppInter {
	public WdaAppImpl() throws RemoteException {
		super();
	}

	private static final long serialVersionUID = -7645009054057448060L;
	public static Queue<DocTask> tasks = new LinkedList<DocTask>();
	private static final Logger log = Logger.getLogger(WdaAppImpl.class);

	public boolean isGenerated(String key, String doctype) throws ErrorTypeException {
		if (!ConfUtils.getTargetTypes().containsKey(doctype)) {
			throw new ErrorTypeException("该类型无效：" + doctype);
		}
		File tarfile = Beanfactory.getFileKeyCoderImpl().parseFile(key, doctype);
		if (!tarfile.isFile()) {
			return false;
		}
		return true;
	}

	public String getText(String key) throws ErrorTypeException {
		String text = null;
		// 从文件里取
		File textFile = Beanfactory.getFileKeyCoderImpl().parseTextFile(key);
		if (textFile.exists()) {
			text = FileUtil.readTxtFile(textFile, AppConfig.getString("config.file.encode"));
		} else {
			File file = null;
			String str = null;
			file = Beanfactory.getFileKeyCoderImpl().parseFile(key, "TXT");
			if (!file.exists() || file.length() <= 0) {
				file = Beanfactory.getFileKeyCoderImpl().parseFile(key, "HTML");
				if (file.exists()) {
					str = FileUtil.readTxtFile(file);
					String charset = FileUtil.matchCharset(str).replaceAll("'", "\"");
					charset = charset.substring(0,
							charset.indexOf("\"") > 0 ? charset.indexOf("\"") : charset.length());
					str = FileUtil.readTxtFile(file, charset.trim());
				}
			} else {
				str = FileUtil.readTxtFile(file);
			}
			if (file != null && file.exists()) {
				try {
					text = FileUtil.delHTMLTag(str) + "/" + getInfo(key);
					FileUtil.wirteInfo(textFile, text);
					index(key, getInfo(key), text);
				} catch (Exception e) {
					log.error(e.getMessage());
				}
			}
		}
		return text;
	}

	private void index(String key, String name, String text) throws Exception {
		if (!AppConfig.getString("config.index").equals("true")) {
			return;
		}
		DocIndexInter indexserver = FarmLuceneFace.inctance()
				.getDocIndex(Beanfactory.getFileKeyCoderImpl().parseLuceneDir());
		try {
			DocMap doc = new DocMap(key);
			doc.put("TEXT", text, Store.YES, Index.ANALYZED);
			doc.put("NAME", name, Store.YES, Index.ANALYZED);
			doc.put("KEY", key, Store.YES, Index.ANALYZED);
			indexserver.indexDoc(doc);
		} finally {
			indexserver.close();
		}
	}

	@Override
	public String getInfo(String key) throws ErrorTypeException, RemoteException {
		String str = null;
		File file = null;
		file = Beanfactory.getFileKeyCoderImpl().parseInfoFile(key);
		if (file.exists()) {
			str = FileUtil.readTxtFile(file);
		} else {
			return "无信息";
		}
		log.debug("读取INFO：" + str);
		return str;
	}

	public String getUrl(String key, String exname) throws ErrorTypeException {
		String path = Beanfactory.getFileKeyCoderImpl().parseDir(key) + File.separator
				+ Beanfactory.getFileKeyCoderImpl().parseFileName(exname);
		String webpaht = AppConfig.getString("config.file.dir.path");
		if (File.separator.equals("/")) {
			webpaht = webpaht.replace("\\\\", "/");
		} else {
			webpaht = webpaht.replace("/", "\\");
		}
		return (webpaht.replace("WEBROOT" + File.separator, "") + File.separator + path).replaceAll("\\\\", "/");
	}

	public void generateDoc(String key, File file, String fileTypeName, String info, String authid)
			throws ErrorTypeException {
		// 获得目录
		// 获得要生成的类型
		FileUtil.wirteInfo(Beanfactory.getFileKeyCoderImpl().parseInfoFile(key), info);
		for (String tkey : ConfUtils.getTargetTypes(fileTypeName).keySet()) {
			File tarfile = Beanfactory.getFileKeyCoderImpl().parseFile(key, tkey);
			log.info("提交任务到队列：" + tarfile);
			File logFile = Beanfactory.getFileKeyCoderImpl().parseLogFile(key);
			FileUtil.wirteLog(logFile, "submitted to taskQueue,waiting...");
			tasks.add(new DocTask(key, file, fileTypeName, tarfile, logFile,
					Beanfactory.getFileKeyCoderImpl().parseInfoFile(key), info, tkey, authid));
		}
	}

	public void generateDoc(String key, File file, String info, String authid) throws ErrorTypeException {
		generateDoc(key, file, FileUtil.getExtensionName(file.getName()), info, authid);
	}

	public boolean isLoged(String key) {
		File file = Beanfactory.getFileKeyCoderImpl().parseLogFile(key);
		return file.isFile();
	}

	public String getlogURL(String key) {
		String path = Beanfactory.getFileKeyCoderImpl().parseDir(key) + File.separator
				+ Beanfactory.getFileKeyCoderImpl().parseLogFileName();
		String webpaht = AppConfig.getString("config.file.dir.path");
		if (File.separator.equals("/")) {
			webpaht = webpaht.replace("\\\\", "/");
		} else {
			webpaht = webpaht.replace("/", "\\");
		}
		return (webpaht.replace("WEBROOT" + File.separator, "") + File.separator + path).replaceAll("\\\\", "/");
	}

	public Set<String> getSupportTypes() throws RemoteException {
		return ConfUtils.getAcceptTypes();
	}

	public void delLog(String key) throws RemoteException {
		File file = Beanfactory.getFileKeyCoderImpl().parseLogFile(key);
		file.deleteOnExit();
	}

	@Override
	public String getLogText(String key) throws RemoteException {
		File log = Beanfactory.getFileKeyCoderImpl().parseLogFile(key);
		String text = FileUtil.readTxtFile(log, AppConfig.getString("config.file.encode"));
		text = text.replaceAll("Log0N", "<br/>");
		return text;
	}

	@Override
	public void clearDir(String key) throws RemoteException {
		String dirStr = Beanfactory.getFileKeyCoderImpl().parseDir(key);
		String paht = (Beanfactory.WEB_DIR + File.separator + dirStr);
		deleteFile(new File(paht));

	}

	// 递归删除文件夹
	private void deleteFile(File file) {
		if (file.exists()) {// 判断文件是否存在
			if (file.isFile()) {// 判断是否是文件
				file.delete();// 删除文件
			} else if (file.isDirectory()) {// 否则如果它是一个目录
				File[] files = file.listFiles();// 声明目录下所有的文件 files[];
				for (int i = 0; i < files.length; i++) {// 遍历目录下所有的文件
					this.deleteFile(files[i]);// 把每个文件用这个方法进行迭代
				}
				file.delete();// 删除文件夹
			}
		} else {
			System.out.println("所删除的文件不存在");
		}
	}

	@Override
	public List<Map<String, String>> getTasksinfo() throws RemoteException {
		List<Map<String, String>> taskcopys = new ArrayList<Map<String, String>>();
		SimpleDateFormat sdf = new SimpleDateFormat("YYYY/MM/dd HH:mm:ss");
		Map<String, String> dicmap = new HashMap<>();
		dicmap.put("1", "等待");
		dicmap.put("2", "处理中");
		for (DocTask task : tasks) {
			Map<String, String> map = new HashMap<>();
			map.put("AUTHID", task.getAuthid());
			map.put("TYPENAME", task.getFileTypeName());
			map.put("INFO", task.getInfo());
			map.put("KEY", task.getKey());
			map.put("TARGETTYPE", task.getTargettype());
			map.put("STATE", dicmap.get(task.getState()));
			map.put("PATH", Beanfactory.getFileKeyCoderImpl().parseDir(task.getKey()));
			map.put("CTIME", task.getCtime() != null ? sdf.format(task.getCtime()) : "");
			map.put("STIME", task.getStime() != null ? sdf.format(task.getStime()) : "");
			taskcopys.add(map);
		}
		return taskcopys;
	}
}
