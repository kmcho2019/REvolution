module TopModule (
    input  a,
    input  b,
    input  c,
    output w,
    output x,
    output y,
    output z
);
    // Combine inputs into a vector
    wire [2:0] inputs = {a, b, c};
    
    // Implement connections using bit selection
    assign w = inputs[2];  // a
    assign x = inputs[1];  // b
    assign y = inputs[1];  // b
    assign z = inputs[0];  // c
endmodule