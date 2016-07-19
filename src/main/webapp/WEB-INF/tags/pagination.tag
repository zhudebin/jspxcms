<%@ tag pageEncoding="UTF-8"%><%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%><%@ taglib prefix="s" uri="http://www.springframework.org/tags"%><%@ taglib prefix="fnx" uri="http://java.sun.com/jsp/jstl/functionsx"%>
<%@ attribute name="pagedList" type="org.springframework.data.domain.Page" required="true" rtexprvalue="true"%>
<script type="text/javascript">
$.cookie('page_size',${pagedList.size},{expires:36500});
$(function(){
	$("#page").keydown(function(event) {
		if (event.keyCode == "13") {
			this.form.submit();
		}
	}).click(function(){
			this.select();
	});
	var pageSize = $("#pageSize").val();
	if(pageSize<=0) {
		$("#pageSize").val(10);
	}
	$("#pageSize").keydown(function(event) {
		if (event.keyCode == "13") {
			$.cookie('page_size',this.value,{expires:36500});
			this.form.submit();
		}
	}).click(function(){
		this.select();
	});
	<c:if test="${pagedList.number!=0 && pagedList.number+1>pagedList.totalPages}">
	$("#page").val(${pagedList.totalPages})[0].form.submit();
	</c:if>
});
</script>
<input type="button" value="&lt;&lt;" onclick="$('#page').val('1');this.form.submit();" style="width:40px;"<c:if test="${fnx:bool(pagedList,'isFirst')}"> disabled="disabeld"</c:if>/>
<input type="button" value="&lt;" onclick="$('#page').val('${pagedList.number}');this.form.submit();" style="width:40px;"<c:if test="${fnx:bool(pagedList,'isFirst')}"> disabled="disabeld"</c:if>/>
<input type="text" id="page" name="page" value="${pagedList.number+1}" style="width:40px;text-align:right;"/> / ${pagedList.totalPages}
<input type="button" value="&gt;" onclick="$('#page').val('${pagedList.number+2}');this.form.submit();" style="width:40px;"<c:if test="${fnx:bool(pagedList,'isLast')}"> disabled="disabeld"</c:if>/>
<input type="button" value="&gt;&gt;" onclick="$('#page').val('${pagedList.totalPages}');this.form.submit();" style="width:40px;"<c:if test="${fnx:bool(pagedList,'isLast')}"> disabled="disabeld"</c:if>/>
<s:message code="pageSize" arguments="<input type='text' id='pageSize' name='page_size' value='${pagedList.size}' style='width:30px;text-align:center;'/>"/>