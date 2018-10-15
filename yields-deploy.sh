#!/usr/bin/env bash

# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

mvn clean compile
mvn -DskipTests package install assembly:assembly

FILE_LIST=""
CLASSIFIER_LIST=""
TYPE_LIST=""
NAME_PREFIX="target/ranger-1.1.0-"

for filename in $(find target -name "*.tar.gz"); do
  FILE_LIST="$FILE_LIST,$filename"
  CLASSIFIER_LIST="$CLASSIFIER_LIST,$(basename ${filename#$NAME_PREFIX} .tar.gz)"
  TYPE_LIST="$TYPE_LIST,tar.gz"
done
for filename in $(find target -name "*.zip"); do
  FILE_LIST="$FILE_LIST,$filename"
  CLASSIFIER_LIST="$CLASSIFIER_LIST,$(basename ${filename#$NAME_PREFIX} .zip)"
  TYPE_LIST="$TYPE_LIST,zip"
done

FILE_LIST=${FILE_LIST#,}
CLASSIFIER_LIST=${CLASSIFIER_LIST#,}
TYPE_LIST=${TYPE_LIST#,}

cat artifacts.pom.xml.in | \
  sed -e "s:%FILE_LIST%:$FILE_LIST:g" |\
  sed -e "s:%CLASSIFIER_LIST%:$CLASSIFIER_LIST:g" |\
  sed -e "s:%TYPE_LIST%:$TYPE_LIST:g" > artifacts.pom.xml

mvn -f artifacts.pom.xml deploy:deploy-file
