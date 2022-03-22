<div>
   <!--$languages = Language::getLanguages();-->
	<hr style="width:100%;">
	<form action="{$currentIndex}&token={$token}" method="post" id="import_form" name="import_form">
		<div style="text-align:left; margin-top:10px;">
			<input name="posSelFormsFiled" type="submit" value="Synchronizuj z Allegro" class="button" />					
		</div>
	</form>
	<hr style="width:100%;">
</div>
{if $transactions}

<div>	
	{*<pre>{$transactions|@print_r}</pre>*}
	<table class="submitAllegroTransaction">
		<tbody>
			{foreach  $transactions as $index => $item}
				<tr class="transSubject" >
					<td>Transakcja</td>
					<td>{$item.adresses.shipment.postBuyFormAdrFullName}</td>
					<td colspan="2">{$item.msg}</td>
					<td colspan="3">
						<div style="display: inline; padding: 5px;">
							<input class = "inlineTransCommit"  type="button" value="Zatwierdź"  {if !( $item.PayStatus == 'Zakończona'  OR  in_array( $item.payType , array( 'wire_transfer' , 'collect_on_delivery' , 'not_specified')) )}disabled{/if}>
						</div>						
						<div style="display: inline; padding: 5px;">
							<button type="button"  onclick="confirmCommit(this);">Zatwierdź bez płatności</button> 							
						</div>						
						<div style="display: inline; float:right; padding: 5px;">
							<a class="button" href="index.php?controller=AdminSubmenu&token={$token}&submitRemove=true&id_transaction={$item.id_transaction}" onclick="return confirm('Usunąć ?');">
							<span>Usuń</span>
							</a>
						</div>
					</td>
				</tr>	
				<tr>
					<td>Id transakcji</td>
					<td>{$item.id_transaction}
					<input type="hidden" name="tansaction[{$item.id_transaction}][id_transaction]" value="{$item.id_transaction}">										
					</td>
					<td>Data</td>
					<td>{$item.timestamp}</td>					
					<td colspan="2">Koszty dostawy</td>
					<td>{$item.shipmentPrice}</td>					
				</tr>
				<tr>					
					<td>Nazwa allegro</td>
					<td>{$item.clientName}</td>
					<td>Email usera allegro</td>
					<td>{$item.clientEmail}</td>		
					<td colspan="2">Kwota transakcji</td>
					<td>{$item.kwota}</td>								
					
				</tr>
				<tr>
					<td>Metoda dostawy Allegro</td>
					<td>{$shipmentMap[$item.shipmentId].shipmentName}</td>
					<td>Metoda dostawy Presta</td>
					<td>
						<select name="tansaction[{$item.id_transaction}][id_carrier]" >
							<option value=""></option>							
								{foreach  $prestaCarriers as $prestaCarrier}
									<option value="{$prestaCarrier.id_carrier}" {if $shipmentMap[$item.shipmentId].presta AND  $shipmentMap[$item.shipmentId].presta.id_carrier == $prestaCarrier.id_carrier }selected{/if}>{$prestaCarrier.name}</option>
								{/foreach}								
						</select>	
					</td>					
					<td colspan="2">Wpłacono</td>
					<td>{$item.wplacono}</td>					
				</tr>
				<tr>
					<td>Metoda płatności Allegro</td>
					<td><strong>{$allegroPayType[$item.payType]}</strong>   |  {$item.payType}</td>
					<td>Metoda płatności Presta</td>
					<td></td>
					<td colspan="3"></td>
				</tr>
				<tr>
					<td>transakcja payU</td>
					<td>{$item.PayId}</td>
					<td>status platności</td>
					<td><strong>{$item.PayStatus}</strong></td>
					<td colspan="3"></td>
				</tr>
				<tr>	
					<td colspan="7">Towary</td>
				</tr>
				<tr>					
					<td>Aukcja</td>
					<td>Nazwa aukcji</td>
					<td>Id presta</td>
					<td>Nazwa presta</td>
					<td>Cena</td>
					<td>Ilość</td>
					<td>Kwota</td>

				</tr>				
				{foreach  $item.items as $i => $prod}
				<tr>					
					<td>{$prod.id_auction}</td>
					<td>{$prod.title}</td>
					<td><input type="text" disabled name="tansaction[{$item.id_transaction}][item][{$prod.id_auction}][id_presta]" value="{$prod.id_product}"></td>
					<td><input class="autocomplete"  type="text"    value="{$prod.name}"></td>
					<td>{$prod.price}</td>
					<td>{$prod.quantity}</td>
					<td>{$prod.amount}</td>
				</tr>				
				{/foreach}			
				<tr>	
					<td colspan="7">Adresy</td>
				</tr>				
				<tr>	
					<td colspan="2">Adres dostawy</td>
					<td colspan="2">Adres  do faktury</td>					
				</tr>									
			{/foreach}			
		</tbody>
	</table>
</div>
<style>
	.transactionForm{
		width: 100%;
	}
	.inlineTransCommit{
		text-align: center;
		
	}
 table.submitAllegroTransaction{
		border-collapse: collapse;
		width: 100%;
	}
	table.submitAllegroTransaction , table.submitAllegroTransaction  th , table.submitAllegroTransaction td{
		border: 1px solid black;
	}
</style>
<script>	
//http://aktywatory.localhost/adminmode/ajax_products_list.php?q=vig&limit=20&timestamp=1416274750363

	function confirmCommit(t){
		var r =  confirm('Zatwierdzić ?');
		if(r){
			var p  = $(t).closest('td')
			var submit  = $('input[type="button"]' , p);
			$(submit).trigger( 'click', true );
		}
		
	}


	$( "input.inlineTransCommit" ).click(function(p) {
				
		var tr = $(this).closest('tr').nextUntil('tr.transSubject');
		// sprawdzić czy są tam elementy do wysłania 
		var inputs  = $('input[name^=tansaction]' , tr);		
		var auctionsInputs  = $('input[name$="[id_presta]"]' , tr);
		if(auctionsInputs.length == 0){
			alert("brak aukcji");
			return;				
		}
		$transObject  = new Array();
		var trans = $('input[name$="[id_transaction]"]' , tr); 
		var transId  = $(trans).val();
		obj = new Object();
		obj[$(trans).attr('name')] = $(trans).val();
		var carier = $('select[name$="[id_carrier]"]' , tr)
		obj[$(carier).attr('name')] = $(carier).val();

		
		$.each(auctionsInputs , function( k, value ){
			var idAuction = $(value).attr('name');
			var idPresta = $(value).val();
			obj[$(value).attr('name')] = $(value).val();
			/*var auctionItem  = {
				id_auction: idAuction,
				id_presta: idPresta
			};
			/*
					var count = $(value).val();
					var td = $(value).parent().parent();
					var kodProduktu  = $('input[name=kodProduktu]' ,  td).val();
					dostawa.items.push(
					{
						kod_produktu: kodProduktu , 
						count: count
					}
					);		
				*/	
		});					
		if(arguments.length == 2){
			obj["submitTransaction"] = "2";	
		}else{
			obj["submitTransaction"] = "1";
		}	

		
		
		$.ajax({
			data: obj,
			dataType: 'json',
			cache:false,
			type: "POST",
			//url: "<?php echo	CHtml::normalizeUrl(array('delivery/commit')) ?>" ,
			error:function(xhr){
				alert(xhr.responseText); 
			},			
			success:function(html){
				if(html.status){
					//window.location.reload();
					 window.location.assign("{$currentIndex}")
					// 	
				}else{
					if(html.alert != undefined)
						alert(html.alert);
					else{
						alert(html);
					}	
				}				
			},
		}
		);		
	});


	
$(function() {	
	function log( message ) {
		$( "<div>" ).text( message ).prependTo( "#log" );
		$( "#log" ).scrollTop( 0 );
	}
	$( ".autocomplete" ).autocomplete({
		source: function (request, response) {
			jQuery.get("ajax_products_list.php", {
				q: request.term,
				timestamp: +new Date(),
				limit: 20
			}, function (data) {
				if(data.length == 0){
				//	alert('0');
				}
				var parsed = [];
				var names = [];
				var rows = data.split("\n");
				
				for (var i=0; i < rows.length; i++) {
					var row = $.trim(rows[i]);
					if (row) {
						row = row.split("|");
						names[names.length] = {
							label: row[0],
							value: row[0], 
							id : row[1]
						}
						parsed[parsed.length] = {
							data: row,
							value: row[0],
							//result: options.formatResult && options.formatResult(row, row[0]) || row[0]
						};
					}
				}				
				response(names);

			});
		},
	minLength: 1,
		change: function( event, ui ) {
			if(ui.item == null){
				this.value = "";
				var td = $(this).parent('td').prev('td');
				$('input' , td).val("");
			}
		}, 
		
		select: function( event, ui ) {
			var td = $(this).parent('td').prev('td');
			$('input' , td).val(ui.item.id);
		}
		});
});
</script>
{/if}	

