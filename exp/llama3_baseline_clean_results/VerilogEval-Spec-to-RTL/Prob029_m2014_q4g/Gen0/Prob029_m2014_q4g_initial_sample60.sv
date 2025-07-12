module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

wire xnor_out;

// Implement XNOR using XOR and inverting the result
assign xnor_out = ~(in1 ^ in2);

// XOR the output of the XNOR with in3
assign out = xnor_out ^ in3;

endmodule