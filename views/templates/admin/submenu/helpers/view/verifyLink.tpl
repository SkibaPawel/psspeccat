<div>
	<input id="verifyLinksCheckbox" type="checkbox" name="onlyActive" value="wartość" checked="checked" />Tylko aktywne
	<input  id="startButton"  name="defaultcomb" type="button" value="najtańsze kombinacje" class="button" onclick="verifyLinks();" />
	
</div>
<div id="info_id">
</div>
<div id="errorinfo_id" style="color: red;">
</div>		
<script type="text/javascript">	
	var products  = {$products} ; 
	var globalAjaxToken = "{$globalAjaxToken}";
	var classname = "ImportZerowy";
	var resultsList ;
	
function verifyLinks(){	
	resultsList = new Array();
	var active  = $('#verifyLinksCheckbox').is(':checked');
	$('#verifyLinksCheckbox').hide();
	$('#startButton').hide();	
	$.each( products, function(index, value) {	
		if( active){
			if(value.active == 0 ){
				return true;
			}	
		}
		var obj  = new Object(); 
		obj.name = index; 
		obj.value =  value; 
		var ret;
		ret  = ajaxCall('verifyLinks', obj);
		if(ret.status){
			$("#info_id").text(index);
			$("#errorinfo_id").text(index + '  '+ ret.data);
			$('#startButton').show();
			result = false; 
			return false;	
		}else{
			$("#errorinfo_id").text('');		
			var item  = value;
			item['id_xml'] = ret.data.data.id_xml;
			if(ret.data.data.link != undefined){
				$("#info_id").text(index +  '  ' + ret.data.data.link);											
				item['link'] = ret.data.data.link;				
			}else{
				$("#info_id").text(index );		
			}
			resultsList.push(item);		
		}
	});
	$("#errorinfo_id").text('');		
	$("#info_id").text('');
	var links  = '';
	var id_xml = '';
	$.each( resultsList, function(index, value) {	
		if(value['link'] != undefined){			
			links += '<a href ="'+value['link']+'">'+value['link']+'</a><br>';	
		}
		id_xml += value['id_xml']+', ';		
	});
	$("#info_id").html('<div>' + links + '</div><br><br><br><div>'+id_xml+'</div>');
	
	// napisy po wszystkim 
	
			
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

