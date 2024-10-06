# Tensor

tensors is the way to work with numbers in drax.

With it, it is possible to work in an extremely high-performance way with arrays of different types and dimensions.

drax provides features natively, allowing you to not worry about additional libraries.

#### **1. Creating Tensors**

A tensor is defined using the `<<i16:: ... >>` notation, where:
- `i16` specifies the data type of the tensor elements (16-bit integers in this case).
- The values are separated by commas to represent the individual elements of the tensor.

For example:

```plaintext
<<i16:: 123, 456, 789, 456, 123>>
```

This creates a 1D tensor with five elements of type `i16` (16-bit integers).

#### **2. Performing Tensor Operations**

The language uses a **pipeline operator (`|>`)** to apply operations sequentially. You can chain multiple tensor operations in a readable and functional manner. The following example illustrates adding multiple tensors together:

```plaintext
res =
    <<i16:: 123,456,789,456,123>>
    |> Tensor.add(<<i16:: 123,456,789,456,123>>)
    |> Tensor.add(<<i16:: 123,456,789,456,123>>)
    |> Tensor.add(<<i16:: 123,456,789,456,123>>)
    |> Tensor.add(<<i16:: 123,456,789,456,123>>)
```

In this case:
1. The initial tensor `<<i16:: 123,456,789,456,123>>` is created.
2. The `Tensor.add` operation is used to add another tensor of the same shape and type.
3. The result of each addition is passed down the pipeline until all tensors are summed.

#### **3. Asserting the Results**

The language provides an `assert` function to validate that the computed tensor matches the expected output. This is useful for testing and ensuring that tensor operations are performed correctly.

```plaintext
assert(res == <<i16:: 615, 2280, 3945, 2280, 615>>, "fail to add mult tensor")
```

- The above statement checks if the result (`res`) is equal to the expected tensor `<<i16:: 615, 2280, 3945, 2280, 615>>`.
- If the assertion fails, it outputs the message `"fail to add mult tensor"`.

#### **4. Example: Adding Multiple Tensors**

Here’s a complete example that demonstrates adding multiple tensors:

```plaintext
res =
    <<i16:: 123,456,789,456,123>>
    |> Tensor.add(<<i16:: 123,456,789,456,123>>)
    |> Tensor.add(<<i16:: 123,456,789,456,123>>)
    |> Tensor.add(<<i16:: 123,456,789,456,123>>)
    |> Tensor.add(<<i16:: 123,456,789,456,123>>)

assert(res == <<i16:: 615, 2280, 3945, 2280, 615>>, "fail to add mult tensor")
```

This example creates a tensor and adds the same tensor four times, producing the final result:

```
<<i16:: 615, 2280, 3945, 2280, 615>>
```
