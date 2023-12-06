for d in ./charts/*/ ; do
  echo "Releasing $d..."
  read CHART_ARCHIVE <<< $(helm package $d | awk -F'Successfully packaged chart and saved it to: ' '{print $2}')
  curl --data-binary "@${CHART_ARCHIVE}" http://172.16.98.151:30588/api/charts
  echo
done