host_path=$PWD
compile_path=/kendryte-standalone-sdk/src/
PRJ_NAME=yolox_detect_example

# compile kmodel
echo "compile kmodel"
python3 $host_path/tools/compile.py model/yolox_nano_224.onnx $host_path/model/yolox_nano_224_k210.kmodel --target=k210 --imgs_dir ./images --legacy
python3 $host_path/tools/compile.py model/yolox_nano_224.onnx $host_path/model/yolox_nano_224_cpu.kmodel --target=cpu --imgs_dir ./images --legacy
python3 $host_path/tools/simulate.py $host_path/model/yolox_nano_224_cpu.kmodel $host_path/images/dog.jpg

# copy kmodel
echo "copy kmodel"
cp $host_path/model/yolox_nano_224_k210.kmodel $host_path/k210/$PRJ_NAME

# copy input data
echo "copy input data"
cp $host_path/dog.bin $host_path/k210/$PRJ_NAME


# copy src files
echo "copy src files"
cp -r $host_path/k210/$PRJ_NAME $compile_path

# build
echo "build"
cmake -S /kendryte-standalone-sdk/ -DPROJ=$PRJ_NAME -DTOOLCHAIN=/opt/kendryte-toolchain/bin
make -j4

# copy results(.bin)
# echo "copy results(.bin)"
# cp $compile_path/$PRJ_NAME/$PRJ_NAME.bin $host_path
