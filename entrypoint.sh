#!/bin/sh

# check if port variable is set or go with default
if [ -z ${PORT+x} ]; then echo "PORT variable not defined, leaving N8N to default port."; else export N8N_PORT="$PORT"; echo "N8N will start on '$PORT'"; fi

# regex function
parse_url() {
  eval $(echo "$1" | sed -e "s#^\(\(.*\)://\)\?\(\([^:@]*\)\(:\(.*\)\)\?@\)\?\([^/?]*\)\(/\(.*\)\)\?#${PREFIX:-URL_}SCHEME='\2' ${PREFIX:-URL_}USER='\4' ${PREFIX:-URL_}PASSWORD='\6' ${PREFIX:-URL_}HOSTPORT='\7' ${PREFIX:-URL_}DATABASE='\9'#")
}

# prefix variables to avoid conflicts and run parse url function on arg url
PREFIX="N8N_DB_" parse_url "$DATABASE_URL"
echo "$N8N_DB_SCHEME://$N8N_DB_USER:$N8N_DB_PASSWORD@$N8N_DB_HOSTPORT/$N8N_DB_DATABASE"
# Separate host and port    
N8N_DB_HOST="$(echo $N8N_DB_HOSTPORT | sed -e 's,:.*,,g')"
N8N_DB_PORT="$(echo $N8N_DB_HOSTPORT | sed -e 's,^.*:,:,g' -e 's,.*:\([0-9]*\).*,\1,g' -e 's,[^0-9],,g')"

export DB_TYPE=postgresdb
export DB_POSTGRESDB_HOST=$N8N_DB_HOST
export DB_POSTGRESDB_PORT=$N8N_DB_PORT
export DB_POSTGRESDB_DATABASE=$N8N_DB_DATABASE
export DB_POSTGRESDB_USER=$N8N_DB_USER
export DB_POSTGRESDB_PASSWORD=$N8N_DB_PASSWORD

sed -i.bak -E 's#this\.manager\?\.[[:space:]]*hasFeatureEnabled\(feature\)[[:space:]]*\?\?[[:space:]]*false#true#g' /usr/local/lib/node_modules/n8n/dist/license.js
sed -i.bak '/getConsumerId()/,/}/ s#return.*;#        return '\''123-;D'\'';#' /usr/local/lib/node_modules/n8n/dist/license.js
sed -i.bak '/getUsersLimit()/,/}/    s#return.*;#        return constants_1.UNLIMITED_LICENSE_QUOTA;#' /usr/local/lib/node_modules/n8n/dist/license.js
sed -i.bak '/getTriggerLimit()/,/}/   s#return.*;#        return constants_1.UNLIMITED_LICENSE_QUOTA;#' /usr/local/lib/node_modules/n8n/dist/license.js
sed -i.bak '/getVariablesLimit()/,/}/ s#return.*;#        return constants_1.UNLIMITED_LICENSE_QUOTA;#' /usr/local/lib/node_modules/n8n/dist/license.js
sed -i.bak '/getAiCredits()/,/}/       s#return.*;#        return 999;#' /usr/local/lib/node_modules/n8n/dist/license.js
sed -i.bak '/getWorkflowHistoryPruneLimit()/,/}/ s#return.*;#        return constants_1.UNLIMITED_LICENSE_QUOTA;#' /usr/local/lib/node_modules/n8n/dist/license.js
sed -i.bak '/getInsightsMaxHistory()/,/}/        s#return.*;#        return 180;#' /usr/local/lib/node_modules/n8n/dist/license.js
sed -i.bak '/getInsightsRetentionMaxAge()/,/}/   s#return.*;#        return 1800;#' /usr/local/lib/node_modules/n8n/dist/license.js
sed -i.bak '/getInsightsRetentionPruneInterval()/,/}/ s#return.*;#        return 2400;#' /usr/local/lib/node_modules/n8n/dist/license.js
sed -i.bak '/getTeamProjectLimit()/,/}/      s#return.*;#        return 200;#' /usr/local/lib/node_modules/n8n/dist/license.js
sed -i.bak -E "s#this\.getFeatureValue\('planName'\)[[:space:]]*\?\?[[:space:]]*'Community';#'Enterprise';#g" /usr/local/lib/node_modules/n8n/dist/license.js

sed -i.bak 's#await this\.manager\.activate(activationKey);#//await this.manager.activate(activationKey);#g' /usr/local/lib/node_modules/n8n/dist/license.js
sed -i.bak 's#await this\.manager\.reload();#//await this.manager.reload();#g' /usr/local/lib/node_modules/n8n/dist/license.js
sed -i.bak 's#await this\.manager\.clear();#//await this.manager.clear();#g' /usr/local/lib/node_modules/n8n/dist/license.js
sed -i.bak 's#await this\.manager\.renew();#//await this.manager.renew();#g' /usr/local/lib/node_modules/n8n/dist/license.js
sed -i.bak 's#await this\.manager\.shutdown();#//await this.manager.shutdown();#g' /usr/local/lib/node_modules/n8n/dist/license.js



# kickstart nodemation
n8n
