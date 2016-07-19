package com.jspxcms.core.web.fore;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import com.jspxcms.core.constant.Constants;
import com.jspxcms.core.domain.Special;
import com.jspxcms.core.service.SpecialService;
import com.jspxcms.core.support.ForeContext;
import com.jspxcms.core.support.Response;
import com.jspxcms.core.support.SiteResolver;

/**
 * SpecialController
 * 
 * @author liufang
 * 
 */
@Controller
public class SpecialController {

	@RequestMapping("/special/{id:[0-9]+}.jspx")
	public String special(@PathVariable Integer id, Integer page,
			HttpServletRequest request, HttpServletResponse response,
			org.springframework.ui.Model modelMap) {
		return special(null, id, page, request, response, modelMap);
	}

	@RequestMapping(Constants.SITE_PREFIX_PATH + "/special/{id:[0-9]+}.jspx")
	public String special(@PathVariable String siteNumber,
			@PathVariable Integer id, Integer page, HttpServletRequest request,
			HttpServletResponse response, org.springframework.ui.Model modelMap) {
		Special special = service.get(id);
		siteResolver.resolveSite(siteNumber, special);

		Response resp = new Response(request, response, modelMap);
		if (special == null) {
			return resp.badRequest("Special not found: " + id);
		}
		modelMap.addAttribute("special", special);
		Map<String, Object> data = modelMap.asMap();
		ForeContext.setData(data, request);
		ForeContext.setPage(data, page);
		return special.getTemplate();
	}

	@Autowired
	private SiteResolver siteResolver;
	@Autowired
	private SpecialService service;
}
