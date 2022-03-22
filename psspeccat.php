<?php
if (!defined('_PS_VERSION_'))
  exit;
 
class psspeccat extends Module
{
  public function __construct()
  {
    $this->name = 'psspeccat';
    //$this->tab = 'psAllegroTab';
    
    $this->version = 1.0;
    $this->author = 'Paweł Skiba';
    $this->need_instance = 0;
    $this->bootstrap = true;
    $this->ps_versions_compliancy = array('min' => '1.6', 'max' => _PS_VERSION_);
 
    parent::__construct();
 
    $this->displayName = $this->l('psspeccat');
    $this->description = $this->l('Spec category');
 
    $this->confirmUninstall = $this->l('Are you sure you want to uninstall?');	    
/*    if (!Configuration::get('psRememberDefaultTime'))  
      $this->warning = $this->l('No Default time value');*/
  }
  
 

  

   
	public function displayForm()
	{
		// Get default Language
		$default_lang = (int)Configuration::get('PS_LANG_DEFAULT');    
		$languages = $this->context->controller->getLanguages();   
			
        $sql = 'SELECT  cms.id_cms as id  ,  cmsl.meta_title as name 
				FROM ' . _DB_PREFIX_ . 'cms as cms
				LEFT JOIN ' . _DB_PREFIX_ . 'cms_lang  cmsl  ON (cms.id_cms = cmsl.id_cms ) where cms.active = 1  and cmsl.id_shop = '. (int) $this->context->shop->id . ' and cmsl.id_lang = '. $this->context->language->id ;
        $list  = Db::getInstance()->executeS($sql);		
		//echo '<pre>'.print_r($list , true ).'</pre>';  die;
					 
		$fields_form[0]['form'] = array(
			'legend' => array(
				'title' => $this->l('Settings'),
			),         
			'input' => array(
				array(
					'type' => 'text',
					'label' => $this->l('domain'),
					'name' => 'domain',
					// 'lang' => true,
					'size' => 64,
					'required' => true
				),
				
			array(
            'type' => 'select',
            'label' => $this->l('CMS'),
            'lang' => true,
            'name' => 'cms',
            
            'required' => true,
            'options' => array(
                        'query' => $list,
                        'id' => 'id',
                        'name' => 'name',
                       ),
                    ),							                           
			),        
			'submit' => array(
				'title' => $this->l('Save'),
				'class' => 'button',
				'name' => 'form0'
			)
		);
		

		
		 
		$helper = new HelperForm();
		 
		// Module, token and currentIndex
		$helper->module = $this;
		$helper->name_controller = $this->name;
		$helper->token = Tools::getAdminTokenLite('AdminModules');
		$helper->currentIndex = AdminController::$currentIndex.'&configure='.$this->name;
		 
		// Language
		$helper->default_form_language = $default_lang;
		$helper->allow_employee_form_lang = $default_lang;
		$helper->languages = $this->context->controller->getLanguages();
		 
		// Title and toolbar
		$helper->title = $this->displayName;
		$helper->show_toolbar = true;        // false -> remove toolbar
		$helper->toolbar_scroll = false;      // yes - > Toolbar is always visible on the top of the screen.
		$helper->submit_action = 'submit'.$this->name;
		
		$helper->toolbar_btn = array(
			'save' =>
			array(
				'desc' => $this->l('Save'),
				'href' => AdminController::$currentIndex.'&configure='.$this->name.'&save'.$this->name.
				'&token='.Tools::getAdminTokenLite('AdminModules'),
			),
			'back' => array(
				'href' => AdminController::$currentIndex.'&token='.Tools::getAdminTokenLite('AdminModules'),
				'desc' => $this->l('Back to list')
			)
		);         
		$helper->toolbar_btn = array(); 
		// Load current value
		$helper->fields_value['domain'] = Configuration::get( $this->name.'Domain'); 
		$helper->fields_value['cms']  = Configuration::get( $this->name.'CMS');		 
		$form0 =  $helper->generateForm($fields_form);     
		return $form0;
	}	
	
	
	
	
  public function getContent()
	{		
			$id_lang = (int)Context::getContext()->language->id;
			$languages = $this->context->controller->getLanguages();
			$default_language = (int)Configuration::get('PS_LANG_DEFAULT');	
		
		$output = null;
	 

		if (Tools::isSubmit('submit'.$this->name))
		{		
			
			Configuration::updateValue($this->name.'CMS', Tools::getValue('cms') ); 
			Configuration::updateValue($this->name.'Domain', Tools::getValue('domain') ); 
			$output .= $this->displayConfirmation($this->l('Settings updated'));			
										
		}
		return $output.$this->displayForm();
	}  
  


	public function install()
	{		
		
		if (!file_exists(_PS_OVERRIDE_DIR_ .'controllers/front/listing')) {
			mkdir(_PS_OVERRIDE_DIR_ .'controllers/front/listing', 0777, true);
		}		
					
		if (parent::install()    and  Db::getInstance()->execute('ALTER TABLE  `'._DB_PREFIX_.'category` ADD  `specjal` INT NOT NULL DEFAULT  \'0\'') )
			return true;								
		return false;				
	
	}
	public function uninstall(){
		return (
			parent::uninstall()   and  Db::getInstance()->execute('ALTER TABLE  `'._DB_PREFIX_.'category` DROP `specjal` ') 			
		);  
	}
}
?>
