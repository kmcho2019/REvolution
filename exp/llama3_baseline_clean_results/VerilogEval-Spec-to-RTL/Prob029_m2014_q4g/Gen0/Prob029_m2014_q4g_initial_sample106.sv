module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

// Calculate the XNOR of in1 and in2
wire xnor_result;
assign xnor_result = ~(in1 ^ in2);

// Calculate the XOR of xnor_result and in3
assign out = xnor_result ^ in3;

endmodule