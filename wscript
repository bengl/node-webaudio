import Options
from os import unlink, symlink, popen
from os.path import exists 
from logging import fatal

srcdir = '.'
blddir = 'build'

def set_options(opt):
  opt.tool_options('compiler_cc')

def configure(conf):
  conf.check_tool('compiler_cc')
  conf.check_tool('node_addon')
  conf.check(lib='portaudio', uselib_store='PA')

def build(bld):
  obj = bld.new_task_gen('cc', 'shlib') 
  obj.uselib = ['PA']
  obj.target = 'portaudio'
  obj.source = 'portaudio.c'

def shutdown():
  if exists("build/default/libportaudio.dylib") and not exists("libportaudio.dylib"):
    symlink("build/default/libportaudio.dylib", "libportaudio.dylib")
  if exists("build/default/libportaudio.so") and not exists("libportaudio.so"):
    symlink("build/default/libportaudio.so", "libportaudio.so")
