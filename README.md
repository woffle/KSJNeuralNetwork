# KSJNeuralNetwork [DEPRECATED] -- Apple has released MLKit
A Neural Network Inference Library Built atop BNNS and MPS With Support For Importing Torch7ES Models.

An Example is included in the KSJAIKIT.xcodeproj for both XOR(LINEAR classifier) and MNIST(CNN classifer).

Using KSJNeuralNetwork for inference on CPU

```objc
KSJNeuralNetwork *neuralNetwork = [[KSJNeuralNetworkCPU alloc] init];
NSValue *weights = ...; //Pointer to your weights array
NSValue *bias = ...; //Pointer to your bias array
BNNSActivationFunction activation = ...; //Activation function if any or BNNSActivationFunctionIdentity if none.
```

Defining a Fully Connected Layer:

```objc
int net_structure [] = {LAYER_INPUT_SIZE,LAYER_OUTPUT_SIZE};
KSJFullyConnectedArchConfiguration *full_conn_arch = [KSJFullyConnectedArchConfiguration archFromStructureBufferWrapped:net_structure weightBuffer:weights biasBuffer:bias dataType:BNNSDataTypeFloat32 activation:activation];

[neuralNetwork addFullyConnectedLayerWithConfiguration:full_conn_arch];
```

Defining a Convolution Layer:

```objc
int net_structure [] = {INPUT_PLANES,OUTPUT_PLANES,KERNEL_W,KERNEL_H,STRIDE_W,STRIDE_H,PAD_W,PAD_H};
KSJConvolutionArchConfiguration *conv_arch = [KSJConvolutionArchConfiguration archFromStructureBufferWrapped:net_structure weightBuffer:weights biasBuffer:bias dataType:BNNSDataTypeFloat32 activation:activation];
[neuralNetwork addConvolutionLayerWithConfiguration:conv_arch];

[neuralNetwork addConvolutionLayerWithConfiguration:conv_arch];
```

Defining a Pooling Layer:

```objc
BNNSPoolingFunction pfunc = BNNSPoolingFunctionMax; // BNNSPoolingFunctionMax or BNNSPoolingFunctionAverage

int net_structure [] = {KERNEL_W,KERNEL_H,STRIDE_W,STRIDE_H,PAD_W,PAD_H};
KSJPoolingArchConfiguration *pool_arch = [KSJPoolingArchConfiguration archFromStructureBufferWrapped:net_structure weightBuffer:NULL biasBuffer:bias poolType:pfunc dataType:BNNSDataTypeFloat32 activation:activation];

[neuralNetwork addMaxPoolingLayerWithConfiguration:pool_arch];
```

N.B. Convolutional Neural Networks and Pooling Networks require you to specify the input size so that subsequent input/output sizes can be calculated based on the convkernels / poolkernels. This is done with the command below:

```objc
[neuralNet setGeometryForConvolutionAndPoolingLayers:CGPointMake(X,Y)];
```

To Build The Neural Network Model based on the specifed architecture you have to call buildGraphWithDataType:

```objc
BNNSDataType datatype = ...; //BNNSDataTypeFloat32 etc.
[neuralNet buildGraphWithDataType:datatype];
```

Once the model has been constructed you may call forward: do peform classification on a single instance.

```objc
NSValue sample = ...; //Pointer to the data which you would like to do the inference on.
NSValue *result = [neuralNet forward:sample];
```

BNNS does not include a SoftMax layer so i've included on that you can execute on after classification using the BNNSExtras class.

```objc
NSValue *softmax = [NSValue valueWithPointer:[KSJBNNSExtras softmax:[result pointerValue] vector_len:RESULT_LENGTH]];
```

For All The Torch7 Dudes I've Created An Extension To Read The .t7ios format with a single command

```objc
NSDictionary *network_components = [KSJNeuralNetwork NeuralNetworkWithTorchESFilePath:[[NSBundle mainBundle] pathForResource:@"YOUR_NET_MODELS_NAME" ofType:@"t7ios"] on:KSJNeuralNetworkDeviceCPU];
KSJNeuralNetwork *neuralNet = network_components[kNeuralNetworkKey];
[neuralNet forward:...]; //GO GO GO GO!
```

Using KSJNeuralNetwork for inference on GPU

...COMING SOON...
