{*
* 2007-2014 PrestaShop
*
* NOTICE OF LICENSE
*
* This source file is subject to the Academic Free License (AFL 3.0)
* that is bundled with this package in the file LICENSE.txt.
* It is also available through the world-wide-web at this URL:
* http://opensource.org/licenses/afl-3.0.php
* If you did not receive a copy of the license and are unable to
* obtain it through the world-wide-web, please send an email
* to license@prestashop.com so we can send you a copy immediately.
*
* DISCLAIMER
*
* Do not edit or add to this file if you wish to upgrade PrestaShop to newer
* versions in the future. If you wish to customize PrestaShop for your
* needs please refer to http://www.prestashop.com for more information.
*
*  @author PrestaShop SA <contact@prestashop.com>
*  @copyright  2007-2014 PrestaShop SA
*  @license    http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
*  International Registered Trademark & Property of PrestaShop SA
*}

{capture name=path}
	<a href="{$link->getPageLink('my-account', true)|escape:'html':'UTF-8'}">
		{l s='My account' mod='favoriteproducts'}</a>
		<span class="navigation-pipe">{$navigationPipe}</span>{l s='My remember products.' mod='psremember'}
{/capture}
{include file="$tpl_dir./breadcrumb.tpl"}

<div id="psrememberproduct_block_account">
	
	<h2>{l s='My remember products.' mod='psremember'}</h2>
{if $psrememberProducts or $messageResult}
	{if $psrememberProducts }
		  {*<script>
		  $(function() {
			$( "#slider-range-max" ).slider({
			  range: "max",
			  min: 1,
			  max: 10,
			  value: 2,
			  slide: function( event, ui ) {
				$( "#amount" ).val( ui.value );
			  }
			});
			$( "#amount" ).val( $( "#slider-range-max" ).slider( "value" ) );
		  });
		  </script>		*}
		<div>
			{foreach from=$psrememberProducts item=psrememberProduct}
			<div class="psremember clearfix">
				<a href="{$link->getProductLink($psrememberProduct.id_product, null, null, null, null, $psrememberProduct.id_shop)|escape:'html':'UTF-8'}" class="product_img_link">
					<img src="{$link->getImageLink($psrememberProduct.link_rewrite, $psrememberProduct.image, 'home')|escape:'html':'UTF-8'}" alt=""/></a>
				<h3><a href="{$link->getProductLink($psrememberProduct.id_product, null, null, null, null, $psrememberProduct.id_shop)|escape:'html':'UTF-8'}">{$psrememberProduct.name|escape:'html':'UTF-8'}</a></h3>
				<div class="product_desc">{$psrememberProduct.description_short|strip_tags|escape:'html':'UTF-8'}</div>				
				<div class="remove">
					<div style="display :none;">{$link|@var_dump} {$moduleLink}</div>
					<select autocomplete="off">
						{foreach from=$options key=k item=v}							
							<option value="{$k}" {if  $psrememberProduct.weeks == $k}selected{/if}>{l s=$v}</option>
						{/foreach}
					</select>					
					<a href="{$moduleLink}?id_product={$psrememberProduct.id_product}" onclick="doPsrememberLinkAction(event , this)">
						<img src="{$img_dir}/ok.png" />			
					</a>
					
					<div class="rememberInfo">
						{l s='Ustawienia zostały zapisane.' mod='psremember'}						
					</div>	
					
				</div>				
			</div>
			{/foreach}
		</div>
		
		<script>
			var infoText = "{l s='Ustawienia zostały zapisane.' mod='psremember'}";
		{literal}
			function doPsrememberLinkAction(event , t){
						event.preventDefault();						
						var href = $(t).attr('href');
						var context = $(t).closest('div');
						var select  = $('select' , context).val(); // find(":selected").val();
						//alert(select); 
						//return;
						$.ajax({
							url: href,
							dataType: 'json',
							async: false,
							method: "POST", 
							data: { week: select},
							error:function(xhr){
								alert(xhr.responseText); 
							},
							cache:false,			
							success:function(resp){	
								//var et = $(event.target).closest("div.remove");
								var ri = $("div.rememberInfo" , $(event.target).closest("div.remove"));
								//$('#rememberInfo').css('left' , event.clientX+'px' );
								//$('#rememberInfo').css('top' , event.clientY+'px' );
								//$('#rememberInfo').css('z-index' , 1000);
								//$('#rememberInfo').css('display' , 'block');								
								if(resp === true){
									$(ri).text(infoText);																		
								}else{
									$(ri).text(resp);	
								}															
								$( ri ).animate({
									opacity: 1.0,
								  }, 250, function() {
									// Animation complete.
									setTimeout(function(){ 
										$( ri ).animate({
											opacity: 0,
											}, 250, function() {
												$(ri).css('z-index' , -1000);												
										// Animation complete.
										});
									}, 3000);
									;	
								});																											
								return;
		
							},
						}
						);						
			}
		</script>
		{/literal}	
	{/if}
	{if $messageResult}
		<div>
			{foreach from=$messageResult item=psrememberMessage}
			<div class="psremember clearfix">				
				<h3>{$psrememberMessage.title|escape:'html':'UTF-8'}</h3>
				<div>{$psrememberMessage.message|escape:'html':'UTF-8'}</div>
				<div class="remove">
					<div style="display :none;">{$link|@var_dump} {$moduleLink}</div>
					<select autocomplete="off">
						{foreach from=$optionsMsg key=k item=v}							
							<option value="{$k}" {if  $psrememberMessage.weeks == $k}selected=true{/if}>{l s=$v}</option>
						{/foreach}
					</select>					
					<a href="{$moduleLink}?id_msg={$psrememberMessage.id_psremember_message}" onclick="doPsrememberLinkAction(event , this)">
						<img src="{$img_dir}/ok.png" />			
					</a>
					
					<div class="rememberInfo">
						{l s='Ustawienia zostały zapisane.' mod='psremember'}						
					</div>	
					
				</div>				
			</div>
			{/foreach}
		</div>			
		{*$messageResult|@print_r*} 
	
	{/if}
{else}
		<p class="warning">{l s='No remember products have been determined just yet. ' mod='psremember'}</p>
{/if}
	<ul class="footer_links">
		<li class="fleft">
			<a href="{$link->getPageLink('my-account', true)|escape:'html':'UTF-8'}"><img src="{$img_dir}icon/my-account.gif" alt="" class="icon" /></a>
			<a href="{$link->getPageLink('my-account', true)|escape:'html':'UTF-8'}">{l s='Back to your account.' mod='psremember'}</a></li>
	</ul>
</div>
<style>
	.rememberInfo {
		border: medium solid; background: white none repeat scroll 0 0;
		padding: 3px;
		opacity: 0;
		display: inline;
	}
	
</style>
