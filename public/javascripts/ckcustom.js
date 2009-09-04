// CHANGE FOR APPS HOSTED IN SUBDIRECTORY
CKRelativePath = '';

CKEDITOR.editorConfig = function( config )
{
  // Define changes to default configuration here. For example:
  // config.language = 'fr';
  // config.uiColor = '#AADC6E';
  config.corePlugins( 'easyUpload', 'en' ) ;

  //config.ContextMenu = ['Generic','Anchor','Flash','Select','Textarea','Checkbox','Radio','TextField','HiddenField','ImageButton','Button','BulletedList','NumberedList','Table','Form'] ;

  // ONLY CHANGE BELOW HERE
  config.SkinPath = CKEDITOR.basePath + 'skins/silver/';

  config.toolbar = 'Easy';
  config.toolbar_Easy = [
          ['Bold','Italic','Underline','StrikeThrough','-'],
          ['OrderedList','UnorderedList','-'],
          ['FontSize'], ['TextColor','BGColor'],
          ['easyImage', 'easyLink', 'Unlink']
  ] ;

  config.toolbar_Simple = [
          ['Source','-','-','Templates'],
          ['Cut','Copy','Paste','PasteWord','-','Print','SpellCheck'],
          ['Undo','Redo','-','Find','Replace','-','SelectAll'],
          '/',
          ['Bold','Italic','Underline','StrikeThrough','-','Subscript','Superscript'],
          ['OrderedList','UnorderedList','-','Outdent','Indent'],
          ['JustifyLeft','JustifyCenter','JustifyRight','JustifyFull'],
          ['Link','Unlink'],
          '/',
          ['Image','Table','Rule','Smiley'],
          ['FontName','FontSize'],
          ['TextColor','BGColor'],
          ['-','About']
  ];

}

CKEDITOR.replace('editor1',
{
  // DON'T CHANGE THESE
  filebrowserBrowseUrl : CKEDITOR.basePath + 'filemanager/browser/default/browser.html?Connector='+CKRelativePath+'/ckeditor/command',
  filebrowserImageBrowseUrl : CKEDITOR.basePath + 'filemanager/browser/default/browser.html?Type=Image&Connector='+CKRelativePath+'/ckeditor/command',
  filebrowserFlashBrowseUrl : CKEDITOR.basePath + 'filemanager/browser/default/browser.html?Type=Flash&Connector='+CKRelativePath+'/ckeditor/command',

  filebrowserUploadUrl : CKRelativePath+'/ckeditor/upload',
  filebrowserImageUploadUrl : CKRelativePath+'/ckeditor/upload?Type=Image',
  filebrowserFlashUploadUrl : CKRelativePath+'/ckeditor/upload?Type=Flash'
});
