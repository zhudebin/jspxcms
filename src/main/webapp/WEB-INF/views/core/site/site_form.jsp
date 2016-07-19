<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fnx" uri="http://java.sun.com/jsp/jstl/functionsx"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="f" uri="http://www.jspxcms.com/tags/form"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<title>Jspxcms管理平台 - Powered by Jspxcms</title>
<jsp:include page="/WEB-INF/views/commons/head.jsp"></jsp:include>
<script type="text/javascript">
$(function() {
	$("#validForm").validate();
	$("input[name='name']").focus();
});
function confirmDelete() {
	return confirm("<s:message code='confirmDelete'/>");
}
</script>
</head>
<body class="c-body">
<jsp:include page="/WEB-INF/views/commons/show_message.jsp"/>
<c:set var="numberExist"><s:message code="site.number.exist"/></c:set>
<div class="c-bar margin-top5">
  <span class="c-position"><s:message code="site.management"/> - <s:message code="${oprt=='edit' ? 'edit' : 'create'}"/></span>
</div>
<form id="validForm" action="${oprt=='edit' ? 'update' : 'save'}.do" method="post">
<tags:search_params/>
<f:hidden name="oid" value="${bean.id}"/>
<f:hidden name="position" value="${position}"/>
<input type="hidden" id="redirect" name="redirect" value="edit"/>
<table border="0" cellpadding="0" cellspacing="0" class="in-tb margin-top5">
  <tr>
    <td colspan="4" class="in-opt">
			<shiro:hasPermission name="core:site:create">
			<div class="in-btn"><input type="button" value="<s:message code="create"/>" onclick="location.href='create.do?${searchstring}';"<c:if test="${oprt=='create'}"> disabled="disabled"</c:if>/></div>
			<div class="in-btn"></div>
			</shiro:hasPermission>
			<shiro:hasPermission name="core:site:copy">
			<div class="in-btn"><input type="button" value="<s:message code="copy"/>" onclick="location.href='create.do?id=${bean.id}&${searchstring}';"<c:if test="${oprt=='create'}"> disabled="disabled"</c:if>/></div>
			</shiro:hasPermission>
			<shiro:hasPermission name="core:site:delete">
			<div class="in-btn"><input type="button" value="<s:message code="delete"/>" onclick="if(confirmDelete()){location.href='delete.do?ids=${bean.id}&${searchstring}';}"<c:if test="${oprt=='create'}"> disabled="disabled"</c:if>/></div>
			</shiro:hasPermission>
			<div class="in-btn"></div>
			<div class="in-btn"><input type="button" value="<s:message code="prev"/>" onclick="location.href='edit.do?id=${side.prev.id}&position=${position-1}&${searchstring}';"<c:if test="${empty side.prev}"> disabled="disabled"</c:if>/></div>
			<div class="in-btn"><input type="button" value="<s:message code="next"/>" onclick="location.href='edit.do?id=${side.next.id}&position=${position+1}&${searchstring}';"<c:if test="${empty side.next}"> disabled="disabled"</c:if>/></div>
			<div class="in-btn"></div>
			<div class="in-btn"><input type="button" value="<s:message code="return"/>" onclick="location.href='list.do?${searchstring}';"/></div>
      <div style="clear:both;"></div>
    </td>
  </tr>
  <tr>
    <td class="in-lab" width="15%"><s:message code="site.parent"/>:</td>
    <td class="in-ctt" width="35%">
      <c:set var="parentName"><c:choose><c:when test="${empty parent}"><s:message code="site.root"/></c:when><c:otherwise><c:out value="${parent.displayName}"/></c:otherwise></c:choose></c:set>
     	<f:hidden id="parentId" name="parentId" value="${parent.id}"/>
	    <f:hidden id="parentIdNumber" value="${parent.id}"/>
	    <f:text id="parentIdName" value="${parentName}" readonly="readonly" style="width:180px;"/><input id="parentIdButton" type="button" value="<s:message code='choose'/>"/>
	    <script type="text/javascript">
	    $(function(){
	    	Cms.f7.site("parentId","parentIdName",{
	    		"settings": {"title": "<s:message code='site.f7.selectSite'/>"},
	    		"params": {
	    			"excludeChildrenId":"${oprt=='edit' ? bean.id : ''}"
	    		}
	    	});
	    });
	    </script>
    </td>
    <td class="in-lab" width="15%"><em class="required">*</em><s:message code="site.org"/>:</td>
    <td class="in-ctt" width="35%">
    	<f:hidden id="orgId" name="orgId" value="${org.id}"/>
	    <f:hidden id="orgIdNumber" value="${org.id}"/>
	    <f:text id="orgIdName" value="${org.displayName}" class="required" readonly="readonly" style="width:180px;"/><input id="orgIdButton" type="button" value="<s:message code='choose'/>"/>
	    <script type="text/javascript">
	    $(function(){
	    	Cms.f7.org("orgId","orgIdName",{
	    		params:{"allowRoot":"false"},
	    		settings: {"title": "<s:message code='org.f7.selectOrg'/>"}
	    	});
	    });
	    </script>
    </td>
  </tr>
  <tr>
    <td class="in-lab" width="15%"><em class="required">*</em><s:message code="site.name"/>:</td>
    <td class="in-ctt" width="35%"><f:text name="name" value="${oprt=='edit' ? (bean.name) : ''}" class="required" maxlength="100" style="width:180px;"/></td>
    <td class="in-lab" width="15%"><s:message code="site.fullName"/>:</td>
    <td class="in-ctt" width="35%"><f:text name="fullName" value="${oprt=='edit' ? (bean.fullName) : ''}" maxlength="100" style="width:180px;"/></td>
  </tr>
    <tr>
    <td class="in-lab" width="15%"><em class="required">*</em><s:message code="site.domain"/>:</td>
    <td class="in-ctt" width="35%">
    	<f:text name="domain" value="${oprt=='edit' ? bean.domain : ''}" class="required" maxlength="100" style="width:150px;"/> &nbsp;
    	<label><f:checkbox name="identifyDomain" value="${bean.identifyDomain}" default="false"/><s:message code="site.identifyDomain"/></label>
    </td>
    <td class="in-lab" width="15%"><em class="required">*</em><s:message code="site.number"/>:</td>
    <td class="in-ctt" width="35%"><f:text name="number" value="${oprt=='edit' ? (bean.number) : ''}" class="{required:true,remote:{url:'check_number.do',type:'post',data:{original:'${oprt=='edit' ? (bean.number) : ''}'}},messages:{remote:'${numberExist}'}}" maxlength="100" style="width:180px;"/></td>
  </tr>
  <tr>
    <td class="in-lab" width="15%"><em class="required">*</em><s:message code="site.templateTheme"/>:</td>
    <td class="in-ctt" width="35%">
    	<c:choose>
    	<c:when test="${oprt=='create'}">
    		<f:text name="templateTheme" value="${bean.templateTheme}" default="default"/>
    	</c:when>
    	<c:otherwise>    	
	    	<select name="templateTheme">
	    		<f:options items="${themeList}" selected="${bean.templateTheme}"/>
	    	</select>
    	</c:otherwise>
    	</c:choose>
    </td>
    <td class="in-lab" width="15%"><s:message code="site.htmlPublishPoint"/>:</td>
    <td class="in-ctt" width="35%">
      <select name="htmlPublishPointId">
        <f:options itemLabel="name" itemValue="id" selected="${bean.htmlPublishPoint.id}" items="${publishPointList}"/>
      </select>
      <label><f:checkbox name="staticHome" value="${bean.staticHome}" default="false"/><s:message code="site.staticHome"/></label>
    </td>
  </tr>
  <c:if test="${oprt == 'edit'}">
  <tr>
    <td class="in-lab" width="15%"><em class="required">*</em><s:message code="site.noPicture"/>:</td>
    <td class="in-ctt" width="85%" colspan="3">
      <script type="text/javascript">
      function fn_noPicture(src) {
        Cms.scaleImg("img_noPicture",300,100,src);
      };
      </script>
      <table width="80%" border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td width="50%" height="100" valign="middle">
            <f:text id="noPicture" name="noPicture" value="${bean.noPicture}" class="required" maxlength="255" onchange="fn_noPicture('${bean.filesUrl}'+this.value);" style="width:180px;"/>
            <input id="noPictureButton" type="button" value="<s:message code='choose'/>"/>
            <script type="text/javascript">
            $(function(){
              Cms.f7.style("noPicture",{
                settings: {"title": "<s:message code="webFile.chooseImage"/>"},
                callbacks: {ok: function() {$("#noPicture").change();}}
              });
            });
            </script>
          </td>
          <td width="50%" align="center">
            <img id="img_noPicture" style="display:none;"/>
          </td>
        </tr>
      </table>
      <c:if test="${!empty bean.noPicture}">
      <script type="text/javascript">
        fn_noPicture("${bean.noPictureUrl}");
      </script>
      </c:if>
    </td>
  </tr>
  </c:if>
  <tr>
    <td class="in-lab" width="15%"><em class="required">*</em><s:message code="site.status"/>:</td>
    <td class="in-ctt" width="35%">
    	<label><f:radio name="status" value="0" checked="${bean.status}" default="0" class="required" /><s:message code="site.status.0"/></label>
    	<label><f:radio name="status" value="1" checked="${bean.status}" class="required" /><s:message code="site.status.1"/></label>
  	</td>
    <td class="in-lab" width="15%"><s:message code="site.def"/>:</td>
    <td class="in-ctt" width="35%">
      <f:checkbox name="def" value="${oprt=='edit' ? bean.def : false}" default="false"/>
    </td>
  </tr>
  
  <tr>
    <td colspan="4" class="in-opt">
      <div class="in-btn"><input type="submit" value="<s:message code="save"/>"/></div>
      <div class="in-btn"><input type="submit" value="<s:message code="saveAndReturn"/>" onclick="$('#redirect').val('list');"/></div>
      <c:if test="${oprt=='create'}">
      <div class="in-btn"><input type="submit" value="<s:message code="saveAndCreate"/>" onclick="$('#redirect').val('create');"/></div>
      </c:if>
      <div style="clear:both;"></div>
    </td>
  </tr>
</table>
</form>
</body>
</html>