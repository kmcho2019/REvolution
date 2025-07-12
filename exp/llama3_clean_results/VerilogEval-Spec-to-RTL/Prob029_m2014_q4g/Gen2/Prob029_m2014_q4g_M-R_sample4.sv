module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

// Intermediate signal for XNOR operation
wire xnor_result;
assign xnor_result = ~(in1 ^ in2);

// Output signal using the intermediate result
assign out = xnor_result ^ in3;

endmodule