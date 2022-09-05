#!/bin/bash

CURR_DIR=$(readlink -f $(dirname "$0"))

usage() {
    cat << EOM
Usage: $(basename "$0") [OPTION]...
  -d WSF build fold
Sample:
    ./do-test.sh -d "~/applications.benchmarking.benchmark.platform-hero-features/build/workload/ResNet50-TensorFlow-EPYC"
EOM
    exit 0
}

WSF_BUILD_DIR=""
CASE_LIST=" test_resnet50_tensorflow_epyc_accuracy_fp32_inference_ap_real
            test_resnet50_tensorflow_epyc_accuracy_fp32_inference_baseline_real
            test_resnet50_tensorflow_epyc_accuracy_fp32_inference_mp_real
            test_resnet50_tensorflow_epyc_accuracy_int8_inference_ap_real
            test_resnet50_tensorflow_epyc_accuracy_int8_inference_baseline_real
            test_resnet50_tensorflow_epyc_accuracy_int8_inference_mp_real
            test_resnet50_tensorflow_epyc_latency_fp32_inference_ap_dummy
            test_resnet50_tensorflow_epyc_latency_fp32_inference_baseline_dummy
            test_resnet50_tensorflow_epyc_latency_fp32_inference_mp_dummy
            test_resnet50_tensorflow_epyc_latency_int8_inference_ap_dummy
            test_resnet50_tensorflow_epyc_latency_int8_inference_baseline_dummy
            test_resnet50_tensorflow_epyc_latency_int8_inference_mp_dummy
            test_resnet50_tensorflow_epyc_throughput_fp32_inference_baseline_dummy
            test_resnet50_tensorflow_epyc_throughput_fp32_inference_baseline_dummy_gated
            test_resnet50_tensorflow_epyc_throughput_fp32_inference_baseline_dummy_pkm
            test_resnet50_tensorflow_epyc_throughput_fp32_inference_mp_dummy
            test_resnet50_tensorflow_epyc_throughput_int8_inference_baseline_dummy
        "

CASE_LIST2=" test_resnet50_tensorflow_epyc_throughput_fp32_inference_ap_dummy
            test_resnet50_tensorflow_epyc_throughput_int8_inference_ap_dummy
            test_resnet50_tensorflow_epyc_throughput_int8_inference_mp_dummy
        "


process_args() {
    while getopts ":d:h" option; do
        case "$option" in
            d) WSF_BUILD_DIR=$OPTARG;;
            h) usage;;
        esac
    done
}

parse_data() {
    if [ -d ${WSF_BUILD_DIR} ]; then 
        pushd ${WSF_BUILD_DIR} > /dev/null
        for case in ${CASE_LIST[@]}; do
            echo "=== case: ${case}"
            echo ctest -V -R $case
            ctest -V -R $case
        done 
        popd > /dev/null
    else
        echo "${WSF_BUILD_DIR} is not a valid workshop"
        exit 1 
    fi
}

process_args "$@"
parse_data
