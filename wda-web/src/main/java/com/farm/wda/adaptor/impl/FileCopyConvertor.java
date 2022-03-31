package com.farm.wda.adaptor.impl;

import java.io.File;
import java.io.IOException;
import org.apache.commons.io.FileUtils;
import org.apache.log4j.Logger;

import com.farm.wda.adaptor.DocConvertorBase;

public class FileCopyConvertor extends DocConvertorBase {
	private static final Logger log = Logger.getLogger(FileCopyConvertor.class);

	@Override
	public void run(File file, String fileTypeName, File targetFile) {
		try {
			FileUtils.copyFile(file, targetFile);
		} catch (IOException e) {
			throw new RuntimeException(e);
		}
	}
}
