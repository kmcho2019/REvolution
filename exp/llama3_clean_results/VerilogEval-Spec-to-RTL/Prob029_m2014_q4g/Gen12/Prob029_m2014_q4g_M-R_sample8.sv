module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

// Intermediate signal for the XNOR operation
wire xnor_result;

// Assign the XNOR result
assign xnor_result = ~(in1 ^ in2);

// Output signal out is the XOR of xnor_result and in3
assign out = xnor_result ^ in3;

endmodule