<div>
</div>
<div id="auctionTable" >
	{if isset($aukcje->sellItemsList) }
		<table ><tbody>
		<tr>
			<th>Nazwa</th>	
			<th>Wystawiono</th>	
			<th>Sprzedano</th>	
			<th>Cena</th>	
			<th>Aukcja</th>	
		</tr>				
		{foreach $aukcje->sellItemsList->item  AS $auction}
			<tr>
				<td>
					{$auction->itemTitle}					
					{*$auction|@print_r*}
				</td>
				<td class="right">
					{$auction->itemStartQuantity}
				</td>
				<td class="right">
					{$auction->itemSoldQuantity}
				</td>
				<td class="right">
					{$auction->itemPrice->item->priceValue}
				</td>					
				<td>
					<a href="http://allegro.pl/i{$auction->itemId}.html">{$auction->itemId}</a>										
				</td>
			</tr>		
		{/foreach}		
		</tbody></table>
		<style>
			.right {
				margin-left: 10px;
				padding: 5px;
			}
			
			#auctionTable
			{
				text-align: center;
			}

			#auctionTable table 
			{
				margin: 0 auto; 
				text-align: left;
			}			
		</style>
	{/if}
{*$aukcje|@print_r*}
</div>
