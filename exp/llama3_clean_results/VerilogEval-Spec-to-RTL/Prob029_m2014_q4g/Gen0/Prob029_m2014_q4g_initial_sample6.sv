module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

wire xnor_out; // Intermediate signal for XNOR output

// XNOR operation
assign xnor_out = ~(in1 ^ in2);

// XOR operation using the intermediate signal and in3
assign out = xnor_out ^ in3;

endmodule