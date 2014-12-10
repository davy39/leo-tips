<?xml version="1.0" encoding="utf-8"?>
<!-- Created by Leo: http://leoeditor.com/leo_toc.html -->
<?xml-stylesheet ekr_test?>
<leo_file xmlns:leo="http://leoeditor.com/namespaces/leo-python-editor/1.1" >
<leo_header file_format="2" tnodes="0" max_tnode_index="0" clone_windows="0"/>
<globals body_outline_ratio="0.5" body_secondary_ratio="0.5">
	<global_window_position top="50" left="50" height="500" width="700"/>
	<global_log_window_position top="0" left="0" height="0" width="0"/>
</globals>
<preferences/>
<find_panel_settings/>
<vnodes>
<v t="davy.20141210142401.7111"><vh>@settings</vh>
<v t="davy.20141210142401.9423"><vh>@string path_to_zim =</vh></v>
<v t="davy.20141210142401.9424"><vh>@string zim_node_name = zim</vh></v>
<v t="davy.20141210142401.7115"><vh>@string rst3_default_path = myLeoZimWiki</vh></v>
<v t="davy.20141210142401.7116"><vh>@bool create_nonexistent_directories = True</vh></v>
<v t="davy.20141210142401.9425"><vh>@string rst_type = @rst</vh></v>
<v t="davy.20141210142401.9426"><vh>@int rst_level = 0</vh></v>
<v t="davy.20141210142401.7113"><vh>@string rst3_write_intermediate_extension = .rst</vh></v>
<v t="davy.20141210142401.7114"><vh>@bool rst3_call_docutils = False</vh></v>
<v t="davy.20141210142401.7110"><vh>@string target_language = rest</vh></v>
</v>
<v t="davy.20141210142401.81"><vh>@button import zim</vh>
<v t="davy.20141210142401.82"><vh>&lt;&lt; import &gt;&gt;</vh></v>
<v t="davy.20141210142401.2496"><vh>&lt;&lt; parameters &gt;&gt;</vh></v>
<v t="davy.20141210142401.83"><vh>parseZimIndex</vh></v>
<v t="davy.20141210142401.85"><vh>rstToLastChild</vh></v>
</v>
<v t="davy.20141210192447.4614"><vh>@button write rst</vh></v>
</vnodes>
<tnodes>
<t tx="davy.20141210142401.2496">pathToZim= c.config.getString('path_to_zim')
rstType = c.config.getString('rst_type')
rstLevel = c.config.getInt('rst_level')
zimNodeName = c.config.getString('zim_node_name')
</t>
<t tx="davy.20141210142401.7110">Set to rest for highlighting rest code in this Leo document</t>
<t tx="davy.20141210142401.7111"></t>
<t tx="davy.20141210142401.7113">The extensions of files written by rst3 plugin if @rstType = @rst</t>
<t tx="davy.20141210142401.7114">False for just writting .rst files 
True for generating .html documents with docutils</t>
<t tx="davy.20141210142401.7115">Path to export your .rst files if you use @string rstType = @rst</t>
<t tx="davy.20141210142401.7116">This option applies to directories specified in filenames in all kinds of @file trees, and to filenames specified in the @path directive.

True:  Leo attempts to create directories if they do not exist.
False: Leo never attempts to create directories.
</t>
<t tx="davy.20141210142401.81">@language python
@first # -*- coding: utf-8 -*-
"""A simple script to import Zim wikis into Leo"""
&lt;&lt; import &gt;&gt;
&lt;&lt; parameters &gt;&gt;
@others

# Create zim node
root=c.findRootPosition()
zimNode=root.insertAfter()
zimNode.h=zimNodeName

# Parse the index file
files = parseZimIndex (pathToZim)

# Do the import
rstNodes={}
rstNodes['0']=zimNode
for level, name, rst in files:
    if level==rstLevel:
        name = "%s %s" % (rstType,name)
    rstNodes[str(level+1)]=rstToLastChild(rstNodes[str(level)],name,rst)
        
c.redraw()</t>
<t tx="davy.20141210142401.82">import re
import urllib</t>
<t tx="davy.20141210142401.83">def parseZimIndex (pathToZim):
    """
    Parse Zim wiki index.rst and return a list of tuples (level, name, path)
    """
    results = []
    pathToZim = g.os_path_abspath(pathToZim)
    pathToIndex = g.os_path_join(pathToZim,'index.rst')
    
    if not g.os_path_exists(pathToIndex):
            g.es(pathToIndex+' doesn\'t exist', color='red')
    
    else: 
            index= open(pathToIndex).read()
            parse = re.findall('(\t*)-\s`(.+)\s&lt;(.+)&gt;`_', index)
    
            if len(parse)==0:
                g.es(pathToIndex+' is not a valid index', color='red')
                return
    
            else:
                for result in parse:
                    level =  len(result[0])
                    name = result[1].decode('utf-8')
                    path = [g.os_path_abspath(g.os_path_join(pathToZim,urllib.unquote(result[2]).decode('utf-8')))]
                    results.append((level,name, path))
    return results</t>
<t tx="davy.20141210142401.85">def rstToLastChild(pos,name,rst):
    """import an rst file as a last child of pos node with the specified name"""
    c.selectPosition(pos,enableRedrawFlag=False)
    c.importCommands.importFilesCommand(rst,'@rst',redrawFlag=False)
    rstNode = pos.getLastChild()
    rstNode.h = name
    return rstNode</t>
<t tx="davy.20141210142401.9423">Path to the root directory of the Zim wiki to import
If empty, this .leo outline have to be in the same directory as Zim wiki index file</t>
<t tx="davy.20141210142401.9424"># Name to your Zim Wiki new node
</t>
<t tx="davy.20141210142401.9425"># Weither to create @rst or @auto-rst nodes</t>
<t tx="davy.20141210142401.9426">Level for which to create the @&lt;rstType&gt; nodes
If empty, no files will be created but just leo outline</t>
<t tx="davy.20141210192447.4614">@language python
from leo.core.leoRst import RstCommands
command=RstCommands(c)
zimNodeName = c.config.getString('zim_node_name')
pos = c.find_h(zimNodeName)
if pos:
    command.processTopTree(pos[0])
else:
    g.es("No %s node. Please run import." % zimNodeName, color='red')
    </t>
</tnodes>
</leo_file>
