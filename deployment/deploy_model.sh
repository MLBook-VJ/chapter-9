# Exit if any command fails
set -e

# Arguments
project_name=$1
experiment_name=$2
uuid=$3
experiment_bucket=$4
prod_bucket=$5

# Set params
dt=$(date '+%Y-%m-%d')
modelpath=gs://$prod_bucket/churn/models/$dt
datapath=gs://$prod_bucket/churn/data/$dt

# Copy model and data from artifacts bucket to prod bucket
gsutil cp gs://$experiment_bucket/$uuid/outputs/model/model.joblib $modelpath/model.joblib
gsutil cp -r gs://$experiment_bucket/$uuid/assets/dataframe $datapath

# Set modelpath in deployment yaml file
sed "s|modelpath|$modelpath|g" deployment.yaml > deployment-$dt.yaml

# Deploy model
kubectl apply -f deployment-$dt.yaml