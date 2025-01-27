# before inference, add all test scans:
cp -r pennovation_dataset-with-1000-test-scans/sequences/02 ./pennovation_dataset/sequences
# remove and recreate folder
rm -rf to-visualize/sequences/02
mkdir -p to-visualize/sequences/02
# copy the predictions
cp -r logs-infer/2022-YOUR_TIMESTAMP/sequences/02/predictions ./to-visualize/sequences/02/predictions
# copy the point clouds
cp -r pennovation_dataset/sequences/02/point_clouds/ ./to-visualize/sequences/02/point_clouds/
