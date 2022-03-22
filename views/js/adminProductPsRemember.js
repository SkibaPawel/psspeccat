$(document).ready(function() {
	var listLink  =  $('a[class="psrememberLink"]');
	var ids = new  Array();
	$.each( listLink, function( index, value ) {
		var href = $(value).attr('href');
		var pos  = href.search('id_product=');
		var id  = href.substring(pos+11);
		ids.push(id);
		var netxTr = 1 ; 
		var c = 1 ; 
	});	
	var token  = listLink[0];
	token = $(token).attr('href');
	var pos  = token.search('&id_product=');
	token = token.substring(0, pos);
	
	
	$.ajax({
		url: token +  '&process=get',
		dataType: 'json',
		data: {ids: ids},
		method: 'POST',
		//url: "<?php echo	CHtml::normalizeUrl(array('price/index')) ?>&ajaxsave" ,
		error:function(xhr){
			alert(xhr.responseText); 
		},
		cache:false,			
		success:function(resp){				
			$.each( listLink, function( index, value ) {
				var href = $(value).attr('href');
				var pos  = href.search('id_product=');
				var id  = href.substring(pos+11);
				var val  = resp[id];
				if(val){
					// link remowe
					href = href+'&process=remove' ;
					var img = $('img' ,value );
					var imgSrc  = $(img).attr('src');
					imgSrc = imgSrc.replace("demail.png", "email.png"); 
					$(img).attr('src' , imgSrc);					
				}else{					
					// link add 
					href = href+'&process=add' ;	
					//var img = $('img' ,value );					
					//var imgSrc  = $(img).attr('src');					
					//imgSrc = imgSrc.replace("demail.png", "email.png"); 
					//$(img).attr('src' , imgSrc);									
					
				}
				$(value).attr('href' , href);
			});				
		},
	}
	);			
	//addPsrememberLinkEventsListeners();
});

	function doPsrememberLinkAction(event , t){
				event.preventDefault();
				var href = $(t).attr('href');
				$.ajax({
					url: href,
					dataType: 'json',
					async: false,
					//data: {ids: ids},
					//method: 'POST',
					//url: "<?php echo	CHtml::normalizeUrl(array('price/index')) ?>&ajaxsave" ,
					error:function(xhr){
						alert(xhr.responseText); 
					},
					cache:false,			
					success:function(resp){	
						//return resp;
						if(resp.status){
							var href = $(t).attr('href');
							// zmiana akcji i obrazka 							
							if(resp.action == 'add'){
								// usunac process add
								var pos  = href.search('&process=');
								var href  = href.substring(0  , pos);
								// link remowe								
								href = href+'&process=remove' ;
								var img = $('img' ,t );
								var imgSrc  = $(img).attr('src');
								imgSrc = imgSrc.replace("demail.png", "email.png"); 
								$(img).attr('src' , imgSrc);					
							}else{					
								var pos  = href.search('&process=');
								var href  = href.substring(0  , pos);								
								// link add 
								href = href+'&process=add' ;	
								var img = $('img' ,t );
								var imgSrc  = $(img).attr('src');
								imgSrc = imgSrc.replace("email.png", "demail.png"); 
								$(img).attr('src' , imgSrc);
							}
							$(t).attr('href' , href);																												
						}			
					},
				}
				);						
	}

	function addPsrememberLinkEventsListeners(){
		$('a[class="psrememberLink"]').click(
			function(event) {
				event.preventDefault();
				var resp  = doPsrememberLinkAction( this);										
				var c = 1;
			}
		);
	
	}	

