package com.jspxcms.ext.service.impl;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;
import java.util.Map;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;

import org.apache.commons.lang3.ArrayUtils;
import org.joda.time.DateTime;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jspxcms.common.orm.Limitable;
import com.jspxcms.common.orm.RowSide;
import com.jspxcms.common.orm.SearchFilter;
import com.jspxcms.core.domain.Site;
import com.jspxcms.core.listener.SiteDeleteListener;
import com.jspxcms.ext.domain.VisitLog;
import com.jspxcms.ext.repository.VisitLogDao;
import com.jspxcms.ext.service.VisitLogService;

@Service
@Transactional(readOnly = true)
public class VisitLogServiceImpl implements VisitLogService, SiteDeleteListener {
	public Page<VisitLog> findAll(Integer siteId, Map<String, String[]> params,
			Pageable pageable) {
		return dao.findAll(spec(siteId, params), pageable);
	}

	public RowSide<VisitLog> findSide(Integer siteId,
			Map<String, String[]> params, VisitLog bean, Integer position,
			Sort sort) {
		if (position == null) {
			return new RowSide<VisitLog>();
		}
		Limitable limit = RowSide.limitable(position, sort);
		List<VisitLog> list = dao.findAll(spec(siteId, params), limit);
		return RowSide.create(list, bean);
	}

	private Specification<VisitLog> spec(final Integer siteId,
			Map<String, String[]> params) {
		Collection<SearchFilter> filters = SearchFilter.parse(params).values();
		final Specification<VisitLog> fsp = SearchFilter.spec(filters,
				VisitLog.class);
		Specification<VisitLog> sp = new Specification<VisitLog>() {
			public Predicate toPredicate(Root<VisitLog> root,
					CriteriaQuery<?> query, CriteriaBuilder cb) {
				Predicate pred = fsp.toPredicate(root, query, cb);
				if (siteId != null) {
					pred = cb.and(pred, cb.equal(root.get("site")
							.<Integer> get("id"), siteId));
				}
				return pred;
			}
		};
		return sp;
	}

	public List<Object[]> trafficByDate(String date, Integer siteId) {
		return dao.trafficByDate(date, siteId);
	}

	public List<Object[]> trafficByTodayAndYesterday(Integer siteId) {
		DateTime dt = new DateTime();
		String today = VisitLog.format(dt.toDate());
		String yesterday = VisitLog.format(dt.plusDays(-1).toDate());
		List<Object[]> list = dao.trafficByDate(today, siteId);
		list.addAll(dao.trafficByDate(yesterday, siteId));
		return list;
	}

	public List<Object[]> trafficByDate(String begin, String end, Integer siteId) {
		return dao.trafficByDate(begin, end, siteId);
	}

	public List<Object[]> urlByDate(String begin, String end, Integer siteId) {
		return dao.urlByDate(begin, end, siteId);
	}

	public VisitLog get(Integer id) {
		return dao.findOne(id);
	}

	@Transactional
	public VisitLog save(String url, String referrer, String ip, String cookie,
			Site site) {
		VisitLog bean = new VisitLog();
		bean.setUrl(url);
		bean.setReferrer(referrer);
		bean.setIp(ip);
		bean.setCookie(cookie);
		bean.setSite(site);
		bean.applyDefaultValue();
		bean = dao.save(bean);
		return bean;
	}

	@Transactional
	public VisitLog delete(Integer id) {
		VisitLog bean = dao.findOne(id);
		dao.delete(bean);
		return bean;
	}

	@Transactional
	public List<VisitLog> delete(Integer[] ids) {
		List<VisitLog> beans = new ArrayList<VisitLog>(ids.length);
		for (Integer id : ids) {
			beans.add(delete(id));
		}
		return beans;
	}

	@Transactional
	public long deleteByDate(String before, Integer siteId) {
		return dao.deleteByDateAndSiteId(before, siteId);
	}

	@Transactional
	public void preSiteDelete(Integer[] ids) {
		if (ArrayUtils.isNotEmpty(ids)) {
			dao.deleteBySiteId(Arrays.asList(ids));
		}
	}

	private VisitLogDao dao;

	@Autowired
	public void setDao(VisitLogDao dao) {
		this.dao = dao;
	}
}
