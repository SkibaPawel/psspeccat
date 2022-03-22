<div>
	<input  id="startButton"  name="defaultcomb" type="button" value="najtańsze kombinacje" class="button" onclick="defaultComb();" />
</div>
<div id="info_id">
</div>
<div id="errorinfo_id" style="color: red;">
</div>		
<script type="text/javascript">
	var products  = {$products} ; 
	var globalAjaxToken = "{$globalAjaxToken}";
	var classname = "ImportZerowy";
	
function defaultComb(){	
	$('#startButton').hide();
	$.each( products, function(index, value) {	
		var obj  = new Object(); 
		obj.name = index; 
		obj.value =  value; 
		var ret;
		ret  = ajaxCall('defComb', obj);
		if(ret.status){
			$("#info_id").text(index);
			$("#errorinfo_id").text(index + '  '+ ret.data);
			$('#startButton').show();
			result = false; 
			return false;	
		}else{
			$("#errorinfo_id").text('');		
			$("#info_id").text(index + ret.data.data);			
		}
	});		
}



function ajaxCall(apiFunc, data){
	var ret = new Object ();
	var sendData = new Object(); 
	sendData.ajax  = 1; 
	sendData.apiFunc = apiFunc;  	
	sendData.data  = data; 
	sendData.token = globalAjaxToken; 
	sendData.classname = classname;
	$.ajax({
		type: 'POST',
		url: '../modules/uniimport/ajax.php',
		async: false,
		cache: false,
		dataType : "json",
		data: sendData,		
			success: function (jsonData)
			{
				if (jsonData.hasError)
				{
					ret.status = 1;
					ret.data = 'json error'; 
					return ret;
				}
				else{
					ret.status = 0;
					ret.data = jsonData; 
					return ret;				


				}

			},
			error: function (XMLHttpRequest, textStatus/*, errorThrown*/) 
			{
					ret.status = 2;
					ret.data = XMLHttpRequest.responseText;
					return ret;
			}
   });
   return ret;
};
	
	
</script>

