module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

// Implement the XNOR operation as the negation of the XOR operation
wire xnor_result;
assign xnor_result = ~(in1 ^ in2);

// Then, apply the XOR operation to this result and the third input
assign out = xnor_result ^ in3;

// Alternatively, we could combine these operations into a single expression
// assign out = (~(in1 ^ in2)) ^ in3;

endmodule