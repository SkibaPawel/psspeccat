<div>
	<div style="display: inline; float: left;  width: 300px;">
				<span style="cursor: pointer;"   onclick ="{literal}{{/literal}$('#xmlManufactuers').toggle();{literal}}{/literal}"><h3> Producenci w xml </h3></span><br />
				<div  id="xmlManufactuers" ' {if !count($newManufactuers)}style="display: none;" {/if} >
					{foreach from=$manufacturers key=myId item=i}
					  			{$myId}<br />
					{/foreach}		
				</div>
		</div>

	<div style="display: inline; float: left;  width: 300px;">
		<span style="cursor: pointer;"   onclick ="{literal}{{/literal} $('#shopManufactuers').toggle(); {literal}}{/literal}"  ><h3> Producenci w sklepie </h3></span><br />
			<div  id="shopManufactuers">
			
			{foreach from=$shopmanufactuers key=myId item=i}
	  			{$myId}<br />
			{/foreach}							
			</div>
	</div>			
	

	<div style="display: inline; float: left;  width: 300px;">
		<span style="cursor: pointer;"  onclick ="{literal}{{/literal}$('#newManufactuers').toggle(); {literal}}{/literal}"><h3> Producenci do dodania</h3></span><br />
				<div  id="newManufactuers" >
				{foreach from=$newManufactuers key=myId item=man}
		  			{$man['name']}<br />
				{/foreach}						
				</div>
	</div>			
</div>
<hr style="width:100%; clear: both;" >
	<div  style="width: 70%;" >
	{$catToDisplay}
	</div>	
{$prodTodisplay}
{$jsscript}
