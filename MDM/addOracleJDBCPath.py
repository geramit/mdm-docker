#####################################################################################
#                                                                                   #
#  Script to add Oracle JDBC PATH WebSphere Variable Hostname                       #
#                                                                                   #
#  Usage : wsadmin -lang jython -f addOracleJDBCPath.py 						    # 
#                                                                                   #
#####################################################################################


def addOracleJDBCPath():

	AdminTask.setVariable('[ -scope Node=DefaultNode01,Server=server1 -variableName ORACLE_JDBC_DRIVER_PATH -variableValue /app/WebSphere/jdbc/ojdbc7.jar]')

	AdminConfig.save()

addOracleJDBCPath()