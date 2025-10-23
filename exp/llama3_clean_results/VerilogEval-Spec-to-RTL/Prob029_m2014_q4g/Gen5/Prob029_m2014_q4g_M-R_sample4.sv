module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// Compute XNOR using AND, OR, and NOT operations
wire xnor_result = (in1 & in2) | (~in1 & ~in2);

// Apply XOR operation with in3
assign out = xnor_result ^ in3;

endmodule