package com.jspxcms.ext.web.back;

import static com.jspxcms.core.constant.Constants.DELETE_SUCCESS;
import static com.jspxcms.core.constant.Constants.EDIT;
import static com.jspxcms.core.constant.Constants.MESSAGE;
import static com.jspxcms.core.constant.Constants.OPRT;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.joda.time.DateTime;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort.Direction;
import org.springframework.data.web.PageableDefault;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.jspxcms.common.orm.RowSide;
import com.jspxcms.common.web.Servlets;
import com.jspxcms.core.constant.Constants;
import com.jspxcms.core.domain.Site;
import com.jspxcms.core.service.OperationLogService;
import com.jspxcms.core.support.Backends;
import com.jspxcms.core.support.Context;
import com.jspxcms.ext.domain.VisitLog;
import com.jspxcms.ext.service.VisitLogService;

@Controller
@RequestMapping("/ext/visit_log")
public class VisitLogController {
	private static final Logger logger = LoggerFactory
			.getLogger(VisitLogController.class);

	@RequiresPermissions("ext:visit_log:list")
	@RequestMapping("list.do")
	public String list(
			@PageableDefault(sort = "id", direction = Direction.DESC) Pageable pageable,
			HttpServletRequest request, org.springframework.ui.Model modelMap) {
		Site site = Context.getCurrentSite();
		Map<String, String[]> params = Servlets.getParamValuesMap(request,
				Constants.SEARCH_PREFIX);
		Page<VisitLog> pagedList = service.findAll(site.getId(), params,
				pageable);
		modelMap.addAttribute("pagedList", pagedList);
		return "ext/visit_log/visit_log_list";
	}

	@RequiresPermissions("ext:visit_log:view")
	@RequestMapping("view.do")
	public String view(
			Integer id,
			Integer position,
			@PageableDefault(sort = "id", direction = Direction.DESC) Pageable pageable,
			HttpServletRequest request, org.springframework.ui.Model modelMap) {
		Site site = Context.getCurrentSite();
		VisitLog bean = service.get(id);
		Map<String, String[]> params = Servlets.getParamValuesMap(request,
				Constants.SEARCH_PREFIX);
		RowSide<VisitLog> side = service.findSide(site.getId(), params, bean,
				position, pageable.getSort());
		modelMap.addAttribute("bean", bean);
		modelMap.addAttribute("side", side);
		modelMap.addAttribute("position", position);
		modelMap.addAttribute(OPRT, EDIT);
		return "ext/visit_log/visit_log_form";
	}

	@RequiresPermissions("ext:visit_log:delete")
	@RequestMapping("delete.do")
	public String delete(Integer[] ids, HttpServletRequest request,
			RedirectAttributes ra) {
		Site site = Context.getCurrentSite();
		validateIds(ids, site.getId());
		List<VisitLog> beans = service.delete(ids);
		for (VisitLog bean : beans) {
			logService.operation("opr.visitLog.batchDelete", bean.getUrl(),
					null, bean.getId(), request);
			logger.info("delete VisitLog, url={}.", bean.getUrl());
		}
		ra.addFlashAttribute(MESSAGE, DELETE_SUCCESS);
		return "redirect:list.do";
	}

	@RequiresPermissions("ext:visit_log:delete")
	@RequestMapping("batch_delete.do")
	public String batchDelete(String before, HttpServletRequest request,
			RedirectAttributes ra) {
		Site site = Context.getCurrentSite();
		long count = service.deleteByDate(before, site.getId());
		logService.operation("opr.visitLog.batchDelete", before, null, null,
				request);
		logger.info("delete VisitLog, date <= {}, count: {}.", before, count);
		ra.addFlashAttribute(MESSAGE, DELETE_SUCCESS);
		return "redirect:list.do";
	}

	@RequiresPermissions("ext:visit_log:traffic_analysis")
	@RequestMapping("traffic_analysis.do")
	public String trafficAnalysis(String begin, String end,
			HttpServletRequest request, org.springframework.ui.Model modelMap) {
		Integer siteId = Context.getCurrentSiteId();
		DateTime dt = new DateTime();
		if (StringUtils.isBlank(end)) {
			end = VisitLog.format(dt.toDate());
		}
		if (StringUtils.isBlank(begin)) {
			begin = VisitLog.format(dt.plusDays(-30).toDate());
		}
		List<Object[]> list = service.trafficByDate(begin, end, siteId);
		modelMap.addAttribute("list", list);
		modelMap.addAttribute("begin", begin);
		modelMap.addAttribute("end", end);
		return "ext/visit_log/visit_traffic_analysis";
	}

	@RequiresPermissions("ext:visit_log:url_analysis")
	@RequestMapping("url_analysis.do")
	public String urlAnalysis(String begin, String end, Pageable pageable,
			HttpServletRequest request, org.springframework.ui.Model modelMap) {
		Integer siteId = Context.getCurrentSiteId();
		DateTime dt = new DateTime();
		if (StringUtils.isBlank(end)) {
			end = VisitLog.format(dt.toDate());
		}
		if (StringUtils.isBlank(begin)) {
			begin = VisitLog.format(dt.plusDays(-30).toDate());
		}
		List<Object[]> list = service.urlByDate(begin, end, siteId);
		modelMap.addAttribute("list", list);
		modelMap.addAttribute("begin", begin);
		modelMap.addAttribute("end", end);
		return "ext/visit_log/visit_url_analysis";
	}

	private void validateIds(Integer[] ids, Integer siteId) {
		for (Integer id : ids) {
			Backends.validateDataInSite(service.get(id), siteId);
		}
	}

	@Autowired
	private OperationLogService logService;
	@Autowired
	private VisitLogService service;
}
