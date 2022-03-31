package com.farm.wcp.api;

import java.rmi.Remote;
import java.rmi.RemoteException;

import com.farm.wcp.api.exception.DocCreatErrorExcepiton;

public interface WcpAppInter extends Remote {

	/**
	 * 创建html知识
	 * 
	 * @param knowtitle
	 *            标题
	 * @param knowtypeId
	 *            分类
	 * @param text
	 *            内容
	 * @param knowtag
	 *            tag
	 * @param groupId
	 *            小组
	 * @param fileId
	 *            内容图
	 * @param currentUserId
	 *            创建用户
	 * @return
	 * @throws RemoteException
	 */
	public String creatHTMLKnow(String knowtitle, String knowtypeId, String text, String knowtag, String currentUserId)
			throws RemoteException,DocCreatErrorExcepiton;

	/**
	 * 对附件做索引
	 * 
	 * @param fileid
	 *            附件id
	 * @param docid
	 *            知识id
	 * @param text
	 *            索引文字
	 * @throws ErrorTypeException
	 * @throws RemoteException
	 */
	public void runLuceneIndex(String fileid, String docid, String text) throws RemoteException;
}
