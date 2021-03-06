<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>

<script type="text/javascript">

	$(function(){
		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "bottom-left"
		});
		$("#addBtn").click(function () {

			$(".time").datetimepicker({
				minView: "month",
				language:  'zh-CN',
				format: 'yyyy-mm-dd',
				autoclose: true,
				todayBtn: true,
				pickerPosition: "bottom-left"
			});
			$.ajax({
				url:"workbench/Activity/getUserList.do",
				dataType:"json",
				success:function (resp) {
					var html = "<option></option>";
					$.each(resp,function (index,elemt) {
						html += ("<option value='"+elemt.id+"'>"+elemt.name+"</option>")
					})
					$("#create-marketActivityOwner").html(html);
					var id = "${sessionScope.user.id}";
					$("#create-marketActivityOwner").val(id);
				}
			})
			$("#createActivityModal").modal("show");
		})

		$("#saveBtn").click(function () {
			$.ajax({
				url:"workbench/Activity/saveActivity.do",
				dataType:"json",
				data:{
					"owner": $.trim($("#create-marketActivityOwner").val()),
					"name": $.trim($("#create-marketActivityName").val()),
					"startDate": $.trim($("#create-startTime").val()),
					"endDate": $.trim($("#create-endTime").val()),
					"cost": $.trim($("#create-cost").val()),
					"description": $.trim($("#create-describe").val())
				},
				type:"post",
				success:function (resp) {
					$("#activityAddForm")[0].reset();
					$("#createActivityModal").modal("hide");
					//pageList(1,2);
					pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
				}
			})
		});
		pageList(1,2);
		$("#searchBtn").click(function () {
			$("#hidden-name").val($.trim($("#search-name").val()));
			$("#hidden-owner").val($.trim($("#search-owner").val()));
			$("#hidden-startDate").val($.trim($("#search-startDate").val()));
			$("#hidden-endDate").val($.trim($("#search-endDate").val()));
			pageList(1,2);

		})
		$("#qx").click(function () {
			$("input[name = xz]").prop("checked",this.checked);
		})


		$("#activityList").on("click",$("input[name = xz]"),function () {
			$("#qx").prop("checked",$("input[name = xz]").length == $("input[name = xz]:checked").length)
		})

		$("#deleteBtn").click(function () {
			var $xz = $("input[name = xz]:checked");
			if($xz.length==0){
				alert("???????????????????????????");
			}else {
				if(confirm("?????????????????????????????????")){
					var  param = "";
					for(var i= 0;i<$xz.length;i++){
						param += "activityid=" + $xz[i].value;
						if(i < $xz.length-1){
							param += "&";
						}
					}
					alert(param);
					$.ajax({
						url:"workbench/Activity/delete.do",
						data:param,
						dataType:"json",
						type:"post",
						success:function (resp) {
							if(resp.success){
								pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
							}else {
								alert("??????????????????");
							}
						}
					})
				}
			}
		})

		$("#editBtn").click(function () {
			$(".time").datetimepicker({
				minView: "month",
				language:  'zh-CN',
				format: 'yyyy-mm-dd',
				autoclose: true,
				todayBtn: true,
				pickerPosition: "bottom-left"
			});
			var $xz = $("input[name = xz]:checked");
			if($xz.length == 0){
				alert("?????????????????????????????????");
			}else if ($xz.length > 1){
				alert("????????????????????????????????????");
			} else {
				$.ajax({
					url:"workbench/Activity/getUserListandActivityById.do",
					type:"get",
					data:{"id":$xz.val()},
					dataType:"json",
					success:function (resp) {
						var html = "<option></option>";
						$.each(resp.list,function (index,elemt) {
							html += ("<option value='"+elemt.id+"'>"+elemt.name+"</option>");
						})
						$("#edit-marketActivityOwner").html(html);
						$("#edit-id").val(resp.activity.id);
						$("#edit-marketActivityOwner").val(resp.activity.owner);
						$("#edit-marketActivityName").val(resp.activity.name);
						$("#edit-startTime").val(resp.activity.startDate);
						$("#edit-endTime").val(resp.activity.endDate);
						$("#edit-cost").val(resp.activity.cost);
						$("#edit-describe").val(resp.activity.description);
						$("#editActivityModal").modal("show");
					}
				})
			}
		})



		$("#updateBtn").click(function () {
			$.ajax({
				url:"workbench/Activity/update.do",
				dataType:"json",
				data:{
					"id":$.trim($("#edit-id").val()),
					"owner": $.trim($("#edit-marketActivityOwner").val()),
					"name": $.trim($("#edit-marketActivityName").val()),
					"startDate": $.trim($("#edit-startTime").val()),
					"endDate": $.trim($("#edit-endTime").val()),
					"cost": $.trim($("#edit-cost").val()),
					"description": $.trim($("#edit-describe").val())
				},
				type:"post",
				success:function (resp) {
					if(resp){
						$("#editActivityModal").modal("hide");
						pageList($("#activityPage").bs_pagination('getOption', 'currentPage')
								,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
					}
				}
			})
		})
	});
	function pageList(pageNo,pageSize) {
		$("#qx").prop("checked",false);

		$("#search-name").val($.trim($("#hidden-name").val()));
		$("#search-owner").val($.trim($("#hidden-owner").val()));
		$("#search-startDate").val($.trim($("#hidden-startDate").val()));
		$("#search-endDate").val($.trim($("#hidden-endDate").val()));
		$.ajax({
			url:"workbench/Activity/pageList.do",
			data:{
				"pageNo":pageNo,
				"pageSize":pageSize,
				"search-name":$.trim($("#search-name").val()),
				"search-owner":$.trim($("#search-owner").val()),
				"search-startDate":$.trim($("#search-startDate").val()),
				"search-endDate":$.trim($("#search-endDate").val())
			},
			dataType:"json",
			success:function (resp) {
				var html = "";
				$.each(resp.list,function (index,elemt) {
					html +='<tr class="active">';
					html +='<td><input name="xz" type="checkbox" value="'+elemt.id+'"></td>';
					html +='<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/Activity/detail.do?id='+elemt.id+'\';">'+elemt.name+'</a></td>';
					html +='<td>'+elemt.owner+'</td>';
					html +='<td>'+elemt.startDate+'</td>';
					html +='<td>'+elemt.endDate+'</td>';
					html +='</tr>';

				});

				$("#activityList").html(html);
				var totalPages = resp.total % pageSize == 0 ? resp.total/pageSize : parseInt(resp.total/pageSize)+1;
				$("#activityPage").bs_pagination({
					currentPage: pageNo, // ??????
					rowsPerPage: pageSize, // ???????????????????????????
					maxRowsPerPage: 20, // ?????????????????????????????????
					totalPages: totalPages, // ?????????
					totalRows: resp.total, // ???????????????

					visiblePageLinks: 3, // ??????????????????

					showGoToPage: true,
					showRowsPerPage: true,
					showRowsInfo: true,
					showRowsDefaultInfo: true,

					onChangePage : function(event, data){
						pageList(data.currentPage , data.rowsPerPage);
					}
				});
			}
		})
	}


</script>
</head>
<body>
	<input type="hidden" id="hidden-name">
	<input type="hidden" id="hidden-owner">
	<input type="hidden" id="hidden-startDate">
	<input type="hidden" id="hidden-endDate">
	<!-- ????????????????????????????????? -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">??</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">??????????????????</h4>
				</div>
				<div class="modal-body">

					<form class="form-horizontal" role="form">
						<input type="hidden" id="edit-id"/>
						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">?????????<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-marketActivityOwner">

								</select>
							</div>
							<label for="edit-marketActivityName" class="col-sm-2 control-label">??????<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-marketActivityName" >
							</div>
						</div>

						<div class="form-group">
							<label for="edit-startTime" class="col-sm-2 control-label">????????????</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-startTime" >
							</div>
							<label for="edit-endTime" class="col-sm-2 control-label">????????????</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-endTime" >
							</div>
						</div>

						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">??????</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost" >
							</div>
						</div>

						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">??????</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe"></textarea>
							</div>
						</div>

					</form>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">??????</button>
					<button type="button" class="btn btn-primary" id="updateBtn">??????</button>
				</div>
			</div>
		</div>
	</div>
	<!-- ????????????????????????????????? -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">??</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">??????????????????</h4>
				</div>
				<div class="modal-body">
				
					<form id="activityAddForm" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">?????????<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-marketActivityOwner">

								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">??????<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-marketActivityName">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startTime" class="col-sm-2 control-label">????????????</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-startTime" readonly>
							</div>
							<label for="create-endTime" class="col-sm-2 control-label">????????????</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-endTime" readonly>
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">??????</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">??????</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">??????</button>
					<button type="button" class="btn btn-primary" id="saveBtn">??????</button>
				</div>
			</div>
		</div>
	</div>
	

	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>??????????????????</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">??????</div>
				      <input class="form-control" type="text" id="search-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">?????????</div>
				      <input class="form-control" type="text" id="search-owner">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">????????????</div>
					  <input class="form-control time" type="text" id="search-startDate" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">????????????</div>
					  <input class="form-control time" type="text" id="search-endDate">
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="searchBtn">??????</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span> ??????</button>
				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> ??????</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> ??????</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx"/></td>
							<td>??????</td>
                            <td>?????????</td>
							<td>????????????</td>
							<td>????????????</td>
						</tr>
					</thead>
					<tbody id="activityList">

					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 30px;">
				<div id="activityPage"></div>
			</div>
			
		</div>
		
	</div>
</body>
</html>