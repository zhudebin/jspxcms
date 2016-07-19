package com.jspxcms.core;

import java.io.File;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.owasp.html.PolicyFactory;
import org.owasp.html.Sanitizers;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;

import com.foxinmy.weixin4j.mp.token.WeixinTokenCreator;
import com.foxinmy.weixin4j.token.FileTokenStorager;
import com.foxinmy.weixin4j.token.TokenHolder;
import com.foxinmy.weixin4j.token.TokenStorager;
import com.jspxcms.core.support.SiteResolver;

@Configuration
public class AppConfig {
	@Bean
	@Primary
	public PolicyFactory policyFactory() {
		PolicyFactory policyFactory = Sanitizers.FORMATTING
				.and(Sanitizers.BLOCKS).and(Sanitizers.STYLES)
				.and(Sanitizers.LINKS).and(Sanitizers.TABLES)
				.and(Sanitizers.IMAGES);
		return policyFactory;
	}

	@Value("#{properties['weixin.appid']}")
	private String weixinAppid;
	@Value("#{properties['weixin.secret']}")
	private String weixinSecret;

	@Bean
	public TokenHolder tokenHoder() {
		if (StringUtils.isBlank(weixinAppid)
				|| StringUtils.isBlank(weixinSecret)) {
			return null;
		}
		WeixinTokenCreator wtc = new WeixinTokenCreator(weixinAppid,
				weixinSecret);
		File tempDir = FileUtils.getTempDirectory();
		File weixinDir = new File(tempDir, "weixin");
		weixinDir.mkdirs();
		TokenStorager ts = new FileTokenStorager(weixinDir.getAbsolutePath());
		TokenHolder th = new TokenHolder(wtc, ts);
		return th;
	}

	@Bean
	public SiteResolver foreSiteResolver() {
		return new SiteResolver();
	}
}
