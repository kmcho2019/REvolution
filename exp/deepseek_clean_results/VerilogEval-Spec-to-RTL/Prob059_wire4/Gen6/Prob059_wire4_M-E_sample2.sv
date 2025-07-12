module TopModule (
    input a,
    input b,
    input c,
    output w,
    output x,
    output y,
    output z
);
    // Bundle inputs into a vector
    wire [2:0] inputs = {a, b, c};
    
    // Create output vector with mapping pattern
    wire [3:0] outputs = {inputs[2], inputs[1], inputs[1], inputs[0]};
    
    // Unpack outputs
    assign {w, x, y, z} = outputs;
endmodule