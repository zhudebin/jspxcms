<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fnx" uri="http://java.sun.com/jsp/jstl/functionsx"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.jspxcms.com/tags/form"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<title>Jspxcms管理平台 - Powered by Jspxcms</title>
<jsp:include page="/WEB-INF/views/commons/head.jsp"></jsp:include>
<style type="text/css">
.ztree li span.button.switch.level0 {visibility:hidden; width:1px;}
.ztree li ul.level0 {padding:0; background:none;}
</style>
<script type="text/javascript">
$(function() {
	var validator = $("#validForm").validate({
		ignore: ":hidden:not(textarea[id^='ueditor_textarea_'])",
		submitHandler: function(form) {
			$(form).find("input[type='submit']").prop("disabled", true);
			$(form).ajaxSubmit({
				success: function(data) {
					$(form).find("input[type='submit']").prop("disabled", false);
					if(data=="ok") {
						alert("<s:message code='operationSuccess'/>");						
					} else {
						alert(data);
					}
				}
			});
			return false;
		},
    errorPlacement: function(label, element) {
      label.insertAfter(element.is("textarea[id^='ueditor_textarea_']") ? $("#"+element.attr("name")) : element);
    }
	});
	validator.focusInvalid = function() {
		if( this.settings.focusInvalid ) {
			try {
				var toFocus = $(this.findLastActive() || this.errorList.length && this.errorList[0].element || []);
				if (toFocus.is("textarea[id^='ueditor_textarea_']")) {
					UE.getEditor("ueditor_"+element.attr("name")).focus();
				} else {
					toFocus.filter(":visible").focus().trigger("focusin");						
				}
			} catch(e) {
			}
		}
  }
});
function wxmodeChange(){
	$(".wx-mode").hide();
	$("#wxmode_"+$("input[name=mode]:checked").val()).show();
}
</script>
</head>
<body class="c-body">
<jsp:include page="/WEB-INF/views/commons/show_message.jsp"/>
<div class="c-bar margin-top5">
  <span class="c-position"><s:message code="info.management"/> - <s:message code="info.massWeixin"/>
</div>
<form id="validForm" action="mass_weixin.do" method="post">
<tags:search_params/>
<f:hidden name="queryNodeId" value="${queryNodeId}"/>
<f:hidden name="queryNodeType" value="${queryNodeType}"/>
<f:hidden name="queryInfoPermType" value="${queryInfoPermType}"/>
<f:hidden id="queryStatus" name="queryStatus" value="${queryStatus}"/>
<table border="0" cellpadding="0" cellspacing="0" class="in-tb margin-top5">
  <tr>
    <td colspan="4" class="in-opt">
		  <div class="ls-btn"><input type="button" value="<s:message code='moveTop'/>" onclick="Cms.moveTop('ids');"/></div>
		  <div class="ls-btn"><input type="button" value="<s:message code='moveUp'/>" onclick="Cms.moveUp('ids');"/></div>
		  <div class="ls-btn"><input type="button" value="<s:message code='moveDown'/>" onclick="Cms.moveDown('ids');"/></div>
		  <div class="ls-btn"><input type="button" value="<s:message code='moveBottom'/>" onclick="Cms.moveBottom('ids');"/></div>
    	<div class="in-btn"></div>
			<div class="in-btn"><input type="button" value="<s:message code="return"/>" onclick="location.href='list.do?queryNodeId=${queryNodeId}&queryNodeType=${queryNodeType}&queryInfoPermType=${queryInfoPermType}&queryStatus=${queryStatus}&${searchstring}';"/></div>
      <div style="clear:both;"></div>
    </td>
  </tr>
  <tr>
    <td class="in-lab" width="15%"><s:message code="info.weixin.mode"/>:</td>
    <td class="in-ctt" width="85%" colspan="3">
   		<label><input type="radio" name="mode" value="all" checked="checked" class="required" onchange="wxmodeChange();"/><s:message code="info.weixin.mode.all"/></label>
   		<label><input type="radio" name="mode" value="group" class="required" onchange="wxmodeChange();"/><s:message code="info.weixin.mode.group"/></label>
   		<label><input type="radio" name="mode" value="preview" class="required" onchange="wxmodeChange();"/><s:message code="info.weixin.mode.preview"/></label>
    </td>
  </tr>
  <tr id="wxmode_group" class="wx-mode" style="display:none;">
    <td class="in-lab" width="15%"><s:message code="info.weixin.group"/>:</td>
    <td class="in-ctt" width="85%" colspan="3">
   		<c:forEach var="group" items="${weixinGroups}">
   		<label><input type="radio" name="groupId" value="${group.id}" class="required"/>${group.name}(${group.count})</label>
   		</c:forEach>
    </td>
  </tr>
  <tr id="wxmode_preview" class="wx-mode" style="display:none;">
    <td class="in-lab" width="15%"><s:message code="info.weixin.previewWxname"/>:</td>
    <td class="in-ctt" width="85%" colspan="3"><f:text name="towxname" class="required" style="width:180px;"/>
    </td>
  </tr>
</table>
<table id="pagedTable" border="0" cellpadding="0" cellspacing="0" class="ls-tb">
  <thead>
  <tr class="ls_table_th">
    <th width="25"><input type="checkbox" onclick="Cms.check('ids',this.checked);"/></th>
    <th width="50"><s:message code="operate"/></th>
    <th width="30" class="ls-th-sort"><span class="ls-sort" pagesort="id">ID</span></th>
    <th></th>
  </tr>
  </thead>
  <tbody>
  <c:forEach var="bean" varStatus="status" items="${list}">
  <tr>
    <td><input type="checkbox" name="ids" value="${bean.id}"/></td>
    <td align="center">
      <a href="javascript:;" onclick="$(this).parent().parent().remove();" class="ls-opt"><s:message code="remove"/></a>
     </td>
    <td><c:out value="${bean.id}"/></td>
    <td>
    	<table border="0" cellpadding="0" cellspacing="0" class="in-tb">
			  <tr>
			    <td class="in-lab" width="15%"><s:message code="info.title"/>:</td>
			    <td class="in-ctt" width="85%" colspan="3">
			   		<input type="text" name="title" value="<c:out value='${bean.title}'/>" style="width:500px;"/>
			   	</td>
			  </tr>
			  <tr>
			    <td class="in-lab" width="15%"><s:message code="info.author"/>:</td>
			    <td class="in-ctt" width="85%" colspan="3">
			   		<input type="text" name="author" value="<c:out value='${bean.author}'/>" style="width:500px;"/>
			   	</td>
			  </tr>
			  <tr>
			    <td class="in-lab" width="15%"><s:message code="info.weixin.sourceUrl"/>:</td>
			    <td class="in-ctt" width="85%" colspan="3">
			   		<input type="text" name="contentSourceUrl" value="<c:out value='${bean.site.protocol}:${bean.urlFull}'/>" style="width:500px;"/>
			   	</td>
			  </tr>
			  <tr>
			    <td class="in-lab" width="15%"><s:message code="info.metaDescription"/>:</td>
			    <td class="in-ctt" width="85%" colspan="3">
			   		<f:textarea name="digest" value="${bean.metaDescription}" class="{maxlength:450}" style="width:500px;height:60px;"/>
			   	</td>
			  </tr>
			  <tr>
			    <td class="in-lab" width="15%"><s:message code="info.weixin.showConverPic"/>:</td>
			    <td class="in-ctt" width="85%" colspan="3">
			   		<label><f:checkbox name="showConverPic" value="true" checked="checked"/>是</label>
			   	</td>
			  </tr>
			  <tr>
			    <td class="in-lab" width="15%"><s:message code="info.weixin.thumb"/>:</td>
			    <td class="in-ctt" width="85%" colspan="3">
			   		<tags:image_upload id="thumb${status.index}" name="thumb" value="${bean.smallImage}" required="true" watermark="false" scale="false" exact="false"/>
			   	</td>
			  </tr>
			  <tr>
			    <td class="in-ctt" width="100%" colspan="4">
			   		<script id="content_${status.index}" name="content_${status.index}" type="text/plain" class="required"></script>
						<script type="text/javascript">
				    $(function() {
				      var ueditor_content_${status.index} = UE.getEditor('content_${status.index}',{
				    	  toolbars: window.UEDITOR_CONFIG.toolbars_Basic,
			          initialFrameHeight:150,
				        imageUrl: "${ctx}${cmscp}/core/upload_image.do?ueditor=true",
				        wordImageUrl: "${ctx}${cmscp}/core/upload_image.do?ueditor=true",
				        fileUrl: "${ctx}${cmscp}/core/upload_file.do;jsessionid=<%=request.getSession().getId()%>?ueditor=true",
				        videoUrl: "${ctx}${cmscp}/core/upload_video.do;jsessionid=<%=request.getSession().getId()%>?ueditor=true",
				        catcherUrl: "${ctx}${cmscp}/core/get_remote_image.do?ueditor=true",
				        imageManagerUrl: "${ctx}${cmscp}/core/image_manager.do",
				        getMovieUrl: "${ctx}${cmscp}/core/get_movie.do",
				        localDomain: ['${!empty GLOBAL.uploadsDomain ? GLOBAL.uploadsDomain : ""}']
				      });
				      ueditor_content_${status.index}.addListener('contentchange',function(){
                this.sync();
                $("#ueditor_textarea_content_${status.index}").valid();
	            });
				      ueditor_content_${status.index}.ready(function() {
				    	  ueditor_content_${status.index}.setContent("${fnx:escapeEcmaScript(bean.text)}");
				    	  $("textarea[name=content_${status.index}]").rules("add",{required:true});
					    });
				    });
						</script>
			   	</td>
			  </tr>
			</table>
    	
    </td>
  </tr>
  </c:forEach>
  </tbody>
</table>
<table border="0" cellpadding="0" cellspacing="0" class="in-tb">
  <tr>
    <td colspan="4" class="in-opt">
      <div class="in-btn"><input type="submit" value="<s:message code="submit"/>"/></div>
      <div style="clear:both;"></div>
    </td>
  </tr>
</table>
</form>
</body>
</html>