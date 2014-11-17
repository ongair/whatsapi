module Whatsapi
	class ProtocolNode

		attr_accessor :data, :tag, :attributes, :children

		@tag
		@attributes
		@children
		@data

	    def initialize(tag, attributes, children, data)
	        @tag = tag
	        @attributes = attributes
	        @children = children
	        @data = data
	    end

		

		# ignore the isCli() function. 
		# lets always assume the response to that is false
		def is_cli
			true
		end

		def node_string indent="", is_child=false
			lt = "<"
			gt = ">"
			nl = "\n"

			if !is_cli
				lt = "&lt;"
				gt = "&gt;"
				nl = "<br />"
				indent.gsub(" ", "&nbsp;")
			end

			ret = indent + lt + @tag

			if !@attribute_hash.nil?
				@attribute_hash.each do |key, value|
					ret += " " + key + "=\"" + value + "\""
				end
			end

			ret += gt

			if @data.length > 0
				if @data.length <= 1024
					# message
					ret += @data
				else
					# raw data
					ret += " " + @data.length + " byte data"
				end
			end

			if @children
				ret += nl
				foo = []
				@children.each do |child|
					# $foo[] = $child->nodeString($indent . "  ", true);
					foo = child.node_string(indent + " ", true)
				end
				ret += foo.join(nl)
				ret += nl + indent
			end

			ret += lt + "/" + @tag + gt

			if !is_child
				ret += nl
				if !is_cli
					ret += nl
				end
			end
			ret
		end

		def self.get_attribute attribute
			ret = ""
			if !@attribute_hash[attribute].nil?
				ret = @attribute_hash[attribute]
			end
			ret
		end

		def node_id_contains needle
			!ProtocolNode.get_attribute("id").nil?
		end

		def get_child tag
			ret = nil
			if @children
				if tag.is_a?(Integer)
					if !@children[tag].nil?
						return @children[tag]
					else
						return nil
					end
				end
				@children.each do |child|
					if child.tag == tag
						return child
					end
					ret = child.get_child(tag)
					if ret
						return ret
					end
				end
			end
			nil
		end

		def has_child tag
			!ProtocolNode.get_child(tag).nil?
		end

		def refresh_times offset=0
			if !@attribute_hash["id"].nil?
				id = @attribute_hash["id"]
				parts = id.split("-")
				parts[0] = Time.now.to_i + offset.seconds
				@attribute_hash["id"] = parts.join("-")
			end
			if !@attribute_hash["t"].nil?
				@attribute_hash["t"] = Time.now.to_i
			end
		end

		def to_string
			readable_node = {
				"tag" => @tag,
				"attribute_hash" => @attribute_hash,
				"children" => @children,
				"data" => @data
			}
		end
	end
end

# class ProtocolNode
# {
#     private $tag;
#     private $attributeHash;
#     private $children;
#     private $data;
#     private static $cli = null;

#     /**
#      * check if call is from command line
#      * @return bool
#      */
#     private static function isCli()
#     {
#         if(self::$cli === null)
#         {
#             //initial setter
#             if(php_sapi_name() == "cli")
#             {
#                 self::$cli = true;
#             }
#             else
#             {
#                 self::$cli = false;
#             }
#         }
#         return self::$cli;
#     }

#     /**
#      * @return string
#      */
#     public function getData()
#     {
#         return $this->data;
#     }

#     /**
#      * @return string
#      */
#     public function getTag()
#     {
#         return $this->tag;
#     }

#     /**
#      * @return string[]
#      */
#     public function getAttributes()
#     {
#         return $this->attributeHash;
#     }

#     /**
#      * @return ProtocolNode[]
#      */
#     public function getChildren()
#     {
#         return $this->children;
#     }

#     public function __construct($tag, $attributeHash, $children, $data)
#     {
#         $this->tag = $tag;
#         $this->attributeHash = $attributeHash;
#         $this->children = $children;
#         $this->data = $data;
#     }

#     /**
#      * @param string $indent
#      * @param bool $isChild
#      * @return string
#      */
#     public function nodeString($indent = "", $isChild = false)
#     {
#         //formatters
#         $lt = "<";
#         $gt = ">";
#         $nl = "\n";
#         if(!self::isCli())
#         {
#             $lt = "&lt;";
#             $gt = "&gt;";
#             $nl = "<br />";
#             $indent = str_replace(" ", "&nbsp;", $indent);
#         }

#         $ret = $indent . $lt . $this->tag;
#         if ($this->attributeHash != null) {
#             foreach ($this->attributeHash as $key => $value) {
#                 $ret .= " " . $key . "=\"" . $value . "\"";
#             }
#         }
#         $ret .= $gt;
#         if (strlen($this->data) > 0) {
#             if (strlen($this->data) <= 1024) {
#                 //message
#                 $ret .= $this->data;
#             } else {
#                 //raw data
#                 $ret .= " " . strlen($this->data) . " byte data";
#             }
#         }
#         if ($this->children) {
#             $ret .= $nl;
#             $foo = array();
#             foreach ($this->children as $child) {
#                 $foo[] = $child->nodeString($indent . "  ", true);
#             }
#             $ret .= implode($nl, $foo);
#             $ret .= $nl . $indent;
#         }
#         $ret .=  $lt . "/" . $this->tag . $gt;

#         if(!$isChild)
#         {
#             $ret .= $nl;
#             if(!self::isCli())
#             {
#                 $ret .= $nl;
#             }
#         }

#         return $ret;
#     }

#     /**
#      * @param $attribute
#      * @return string
#      */
#     public function getAttribute($attribute)
#     {
#         $ret = "";
#         if (isset($this->attributeHash[$attribute])) {
#             $ret = $this->attributeHash[$attribute];
#         }

#         return $ret;
#     }

#     /**
#      * @param string $needle
#      * @return boolean
#      */
#     public function nodeIdContains($needle)
#     {
#         return (strpos($this->getAttribute("id"), $needle) !== false);
#     }

#     //get children supports string tag or int index
#     /**
#      * @param $tag
#      * @return ProtocolNode
#      */
#     public function getChild($tag)
#     {
#         $ret = null;
#         if ($this->children) {
#             if(is_int($tag))
#             {
#                 if(isset($this->children[$tag]))
#                 {
#                     return $this->children[$tag];
#                 }
#                 else
#                 {
#                     return null;
#                 }
#             }
#             foreach ($this->children as $child) {
#                 if (strcmp($child->tag, $tag) == 0) {
#                     return $child;
#                 }
#                 $ret = $child->getChild($tag);
#                 if ($ret) {
#                     return $ret;
#                 }
#             }
#         }

#         return null;
#     }

#     /**
#      * @param $tag
#      * @return bool
#      */
#     public function hasChild($tag)
#     {
#         return $this->getChild($tag) == null ? false : true;
#     }

#     /**
#      * @param int $offset
#      */
#     public function refreshTimes($offset = 0)
#     {
#         if (isset($this->attributeHash['id'])) {
#             $id = $this->attributeHash['id'];
#             $parts = explode('-', $id);
#             $parts[0] = time() + $offset;
#             $this->attributeHash['id'] = implode('-', $parts);
#         }
#         if (isset($this->attributeHash['t'])) {
#             $this->attributeHash['t'] = time();
#         }
#     }
    
    
#     /**
#      * Print human readable ProtocolNode object
#      *
#      * @return string
#      */
#     public function __toString()
#     {
#         $readableNode = array(
#             'tag'           => $this->tag,
#             'attributeHash' => $this->attributeHash,
#             'children'      => $this->children,
#             'data'          => $this->data
#         );

#         return print_r( $readableNode, true );
#     }

# }
