module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

// XNOR implementation
wire xnor_out;
assign xnor_out = ~(in1 ^ in2);

// XOR implementation
assign out = xnor_out ^ in3;

endmodule