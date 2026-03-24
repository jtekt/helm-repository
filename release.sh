for d in ./charts/*/ ; do
  echo "Releasing $d..."
  read CHART_ARCHIVE <<< $(helm package $d | awk -F'Successfully packaged chart and saved it to: ' '{print $2}')
  curl --data-binary "@${CHART_ARCHIVE}" https://chartmuseum.jtektrnd.net/api/charts
  echo
done