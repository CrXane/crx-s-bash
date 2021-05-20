#include <amxmodx>

new path[128];
new args[64];
new firstfile[64];
new outlen;
new dir;

public plugin_init(){
 register_plugin("0x63 0x72 0x78", "0xCrx", "CrXane");

 register_srvcmd("cd", "srvcmd_cd");
 register_srvcmd("ls", "srvcmd_ls");
 register_srvcmd("cat", "srvcmd_cat");
 register_srvcmd("pwd", "srvcmd_pwd");
}

public srvcmd_cd(){
 read_args(args, charsmax(args));
 
 if (!args[0]){
  path[0] = 0;
  server_print("crx@cstrike");
  
  return PLUGIN_HANDLED;
 }
 
 if (contain(args, "/")){
  server_print("crx@%s slash charactets are not allowed", path)
  return PLUGIN_HANDLED;
 }
 
 if (equal(args, "..") || equal(args, ".")){
  if (path[0])
   RemDir();
   
  else
   AddDir();

  return PLUGIN_HANDLED;
 }
   
 AddDir();
 
 if (dir_exists(path)){
  dir = open_dir(path, firstfile, charsmax(firstfile))
  if(dir){
   server_print("crx@%s", path);
   close_dir(dir);
  }
  else server_print("error opening folder");
 }
 else server_print("crx@%s folder not found", path);
 
 return PLUGIN_CONTINUE;
}

public srvcmd_ls(){
 dir = open_dir(path, firstfile, charsmax(firstfile))
 if (dir){
   for (new i = 0; i < 999; i++){
   read_dir(path, i, args, charsmax(args), outlen);
   
   if (!args[0]) break;
  
   if (equal(args, "..") || equal(args, "."))
    return PLUGIN_CONTINUE;

   AddDir();
   
   if (dir_exists(path))
    server_print("crx@%s folder", path);
   
   else
    server_print("crx@%s/%s", path);
    
   RemDir();
   }
  }
 close_dir(dir);
 else server_print("error reading files");
 return PLUGIN_HANDLED
}

public srvcmd_cat(){
 dir = open_dir(path, firstfile, charsmax(firstfile))
 if (dir){
  read_args(args, charsmax(args));
 
  if (!args[0] || contain(args, "/") || equal(args, "..") || equal(args, '.')){
   server_print("invalid file name");
   return PLUGIN_HANDLED;
  }
 
  new i = 0, outlen = 0;
  while (read_file(args, i, args, charsmax(args), outlen) != 0){
   server_print("%d) %s", i, args);
   i++;
  }
 
  close_dir(dir);
 }
 else server_print("error opening folder");
 return PLUGIN_HANDLED
}

public srvcmd_pwd()
 server_print("crx@%s", path);

///////////////////
////// STOCKS /////
///////////////////

stock AddDir(){
 if (path[0])
  format(path, charsmax(path), "%s/%s", path, args);
 
 else
  format(path, charsmax(path), "%s", args);
}

stock RemDir(){
 new len = strlen(args);
 new len2 = strlen(path);
 new val = len2 - len + 1;
 
 for (new i = 1; i <= val; i++)
  path[len - i] = 0;
}
