<!-----------------------------------------------------------------------********************************************************************************Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corpwww.coldbox.org | www.luismajano.com | www.ortussolutions.com********************************************************************************Author 	    :	Luis MajanoDate        :	September 23, 2005Description :	This is a cfc that all event handlers should extendModification History:01/12/2006 - Added fix for whitespace management.06/08/2006 - Updated for coldbox07/29/2006 - Datasource support via getdatsource()-----------------------------------------------------------------------><cfcomponent hint="This is the event handler base cfc."			 output="false"			 extends="coldbox.system.FrameworkSupertype"			 serializable="false"><!------------------------------------------- CONSTRUCTOR ------------------------------------------->	<!--- Public Exposed Functionality Properties --->	<cfscript>		instance				= structnew();		this.event_cache_suffix = "";		this.prehandler_only 	= "";		this.prehandler_except 	= "";		this.posthandler_only 	= "";		this.posthandler_except = "";		this.allowedMethods 	= structnew();		this.defaultAction 		= "";	</cfscript>		<cffunction name="init" access="public" returntype="any" output="false" hint="The event handler controller">		<cfargument name="controller" type="any" required="true" hint="coldbox.system.web.Controller">		<cfscript>			// Unique Instance ID for the object.			instance.__hash = hash(createObject('java','java.lang.System').identityHashCode(this));						// Register Controller			variables.controller = arguments.controller;			// Register LogBox			variables.logBox = arguments.controller.getLogBox();			// Register Log object			variables.log = variables.logBox.getLogger(this);			// Register Flash RAM			variables.flash = arguments.controller.getRequestService().getFlashScope();						// Inject user dependencies.			if(Len(Trim(getController().getSetting("UDFLibraryFile")))){				includeUDF(getController().getSetting("UDFLibraryFile"));			}						return this;		</cfscript>	</cffunction><!------------------------------------------- PUBLIC ------------------------------------------->		<!--- _actionExists --->
    <cffunction name="_actionExists" output="false" access="public" returntype="boolean" hint="Checks if an action is defined, either public or private">
    	<cfargument name="action" type="string" required="true" hint="The action to search for"/>    	<cfreturn ( structKeyExists(this,arguments.action) OR structKeyExists(variables,arguments.action) )>    </cffunction>	<!--- Invoker Mixin --->	<cffunction name="_privateInvoker" hint="calls private/packaged/public methods. Used internally by coldbox to execute private events" access="public" returntype="any" output="false">		<!--- ************************************************************* --->		<cfargument name="method" 		 type="string" required="true"   hint="Name of the method to execute">		<cfargument name="argCollection" type="struct" required="false"  hint="Can be called with an argument collection struct">		<!--- ************************************************************* --->		<cfset var results = "">		<cfset var key = "">				<!--- Determine type of invocation --->		<cfif structKeyExists(arguments,"argCollection")>			<cfinvoke method="#arguments.method#" 					  returnvariable="results" 					  argumentcollection="#arguments.argCollection#" />		<cfelse>			<cfinvoke method="#arguments.method#" 					  returnvariable="results" />		</cfif>				<!--- Return results if Found --->		<cfif isDefined("results")>			<cfreturn results>		</cfif>	</cffunction><!------------------------------------------- PRIVATE -------------------------------------------></cfcomponent>