module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

wire xnor_out;

// Explicit XNOR operation
assign xnor_out = ~(in1 ^ in2);

// XOR of XNOR output with in3
assign out = xnor_out ^ in3;

endmodule