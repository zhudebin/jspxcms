<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.jspxcms.core.domain.*,java.util.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fnx" uri="http://java.sun.com/jsp/jstl/functionsx"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
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
<c:if test="${!empty refreshLeft}">
parent.frames['left'].location.href="left.do";
</c:if>
function dblClickExpand(treeId, treeNode) {
  return treeNode.level > 0;
}
function isOpen(id) {
  return id==11;
}
function srcOnClick(event, treeId, treeNode) {
  var srcTree = $.fn.zTree.getZTreeObj("srcTree");
  srcTree.checkNode(treeNode,null,false,true);
}
function destOnClick(event, treeId, treeNode) {
  var destTree = $.fn.zTree.getZTreeObj("destTree");
  destTree.checkNode(treeNode,null,false);
}
function srcOnCheck() {
  var srcTree = $.fn.zTree.getZTreeObj("srcTree");
  var checkedNodeArr = srcTree.getCheckedNodes(true);
  var destTree = $.fn.zTree.getZTreeObj("destTree");
  var destNodes = destTree.getNodes();
  destTree.setChkDisabled(destNodes[0],false,false,true);
  for(var i=0,len=checkedNodeArr.length;i<len;i++) {
    var destNode = destTree.getNodeByTId(checkedNodeArr[i].tId);
    destTree.checkNode(destNode,false);
    destTree.setChkDisabled(destNode,true,false,true);    
  }
}
var srcSetting = {
  check: {
    enable: true,
    chkboxType: {"Y":"s","N":""}
  },
  callback: {
    onClick: srcOnClick,
    onCheck: srcOnCheck
  },
  view: {
    dblClickExpand: dblClickExpand
  },
  data: {
    simpleData: {
      enable: true
    }
  }
};
var destSetting = {
  check: {
    enable: true,
    chkStyle: "radio",
    radioType: "all"
  },
  callback: {
    onClick: destOnClick
  },
  view: {
    dblClickExpand: dblClickExpand
  },
  data: {
    simpleData: {
      enable: true
    }
  }
};
var srcNodes =[
  <c:forEach var="node" items="${list}" varStatus="status">
    {"id":${node.id},"pId":<c:out value="${node.parent.id}" default="null"/>,"name":"${node.name}",<c:choose><c:when test="${empty node.parent}">"open":true,"nocheck":true</c:when><c:otherwise>"open":${fnx:contains_oxo(selectedPids,node.id)},"checked":${empty noChecked && fnx:contains_oxo(selectedIds,node.id)}</c:otherwise></c:choose>}<c:if test="${!status.last}">,</c:if>
  </c:forEach>
];
var destNodes =[
  <c:forEach var="node" items="${list}" varStatus="status">
    {"id":${node.id},"pId":<c:out value="${node.parent.id}" default="null"/>,"name":"${node.name}",<c:choose><c:when test="${empty node.parent}">"open":true</c:when><c:otherwise>"open":${fnx:contains_oxo(selectedPids,node.id)}</c:otherwise></c:choose>}<c:if test="${!status.last}">,</c:if>
  </c:forEach>
];
$(function() {
  var srcTree = $.fn.zTree.init($("#srcTree"), srcSetting, srcNodes);
  var destTree = $.fn.zTree.init($("#destTree"), destSetting, destNodes);
  srcOnCheck();
  $("#validForm").validate();
  $("#validForm").submit(function(){
    var srcCheckedArr = srcTree.getCheckedNodes(true);
    var destCheckedArr = destTree.getCheckedNodes(true);
    if(srcCheckedArr.length==0) {
      alert("<s:message code='node.pleaseSelectMergeSrcNode'/>");
      return false;
    }
    if(destCheckedArr.length==0) {
      alert("<s:message code='node.pleaseSelectDestNode'/>");
      return false;
    }
    for(var i=0,len=srcCheckedArr.length;i<len;i++) {
      $("<input>",{
        "type": "hidden",
        "name": "ids",
        "value": srcCheckedArr[i].id
      }).appendTo($(this));
    }
    $("<input>",{
      "type": "hidden",
      "name": "id",
      "value": destCheckedArr[0].id
    }).appendTo($(this));
  });
});
</script>
</head>
<body class="c-body">
<jsp:include page="/WEB-INF/views/commons/show_message.jsp"/>
<div class="c-bar margin-top5">
  <span class="c-position"><s:message code="node.management"/> - <s:message code="merge"/></span>
</div>
<form id="validForm" action="merge_submit.do" method="post">
<tags:search_params/>
<f:hidden name="queryParentId" value="${queryParentId}"/>
<f:hidden name="showDescendants" value="${showDescendants}"/>
<f:hidden name="position" value="${position}"/>
<table border="0" cellpadding="0" cellspacing="0" class="in-tb margin-top5">
  <tr>
    <td colspan="2" class="in-opt">
      <div class="in-btn"><input type="button" value="<s:message code="return"/>" onclick="location.href='list.do?queryParentId=${queryParentId}&showDescendants=${showDescendants}&${searchstring}';"/></div>
      <div style="clear:both;"></div>
    </td>
  </tr>
  <tr>
    <td colspan="2" class="in-ctt">
      <span style="font-weight:bold;padding-left:5px;"><s:message code="node.deleteMergedNode"/></span>: &nbsp;
      <label><f:radio name="deleteMergedNode" value="true" checked="${deleteMergedNode}" default="true"/><s:message code="yes"/></label>
      <label><f:radio name="deleteMergedNode" value="false" checked="${deleteMergedNode}"/><s:message code="no"/></label>
    </td>
  </tr>
  <tr>
    <th width="50%" align="center" class="in-ctt"><s:message code="node.mergeSrcNode"/></th>
    <th width="50%" align="center" class="in-ctt"><s:message code="node.destNode"/></th>
  </tr>
  <tr>
    <td width="50%" valign="top" class="in-ctt">
      <ul id="srcTree" class="ztree"></ul>
    </td>
    <td width="50%" valign="top" class="in-ctt">
      <ul id="destTree" class="ztree"></ul>
    </td>
  </tr>
  <tr>
    <td colspan="2" class="in-opt">
      <div class="in-btn"><input type="submit" value="<s:message code="submit"/>"/></div>
      <div style="clear:both;"></div>
    </td>
  </tr>
</table>
</form>
</body>
</html>