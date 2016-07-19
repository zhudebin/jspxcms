package com.jspxcms.core.commercial;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.foxinmy.weixin4j.exception.WeixinException;
import com.foxinmy.weixin4j.token.TokenHolder;
import com.jspxcms.common.web.PathResolver;
import com.jspxcms.core.service.InfoQueryService;
import com.jspxcms.core.service.OperationLogService;

public class Weixin {
	public static String massWeixinForm(Integer[] ids, Integer queryNodeId,
			Integer queryNodeType, Integer queryInfoPermType,
			String queryStatus, HttpServletRequest request,
			org.springframework.ui.Model modelMap, TokenHolder tokenHolder,
			InfoQueryService query) throws WeixinException {
		return "redirect:/support_genuine.jsp";
	}

	public static void massWeixin(String mode, Integer groupId,
			String towxname, String[] title, String[] author,
			String[] contentSourceUrl, String[] digest,
			Boolean[] showConverPic, String[] thumb,
			HttpServletRequest request, HttpServletResponse response,
			org.springframework.ui.Model modelMap, TokenHolder tokenHolder,
			OperationLogService logService, PathResolver pathResolver)
			throws IOException {
	}
}
