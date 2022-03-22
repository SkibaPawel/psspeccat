<?php

class CategoryController extends CategoryControllerCore
{
	
    public function init()
    {
	
        $id_category = (int) Tools::getValue('id_category');
        $this->category = new Category(
            $id_category,
            $this->context->language->id
        );                           
		if($this->category->specjal){			
			$id_customer =  $this->context->customer->id; 		
			if($id_customer){			
				$shop  = new Shop($this->context->customer->id_shop);				
				if($shop->domain  ==  Configuration::get('psspeccatDomain' , null , null , $this->context->shop->id ) ){  
					return parent::init();				
				}						
			}
			header('HTTP/1.1 301 Moved Permanently');
			header('Location: ' . $this->context->link->getCMSLink( Configuration::get('psspeccatCMS' , null , null , $this->context->shop->id ) , null , null , $this->context->language->id , $this->context->shop->id ));  
			 
			 exit;							  			
		}	
		parent::init();
    }

}
