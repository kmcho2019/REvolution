module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// Define intermediate signal for XNOR operation
wire xnor_out;

// Use simplified expression for XNOR operation
assign xnor_out = ~(in1 ^ in2);

// Use simplified expression for final output, combining XNOR result with XOR operation
assign out = xnor_out ^ in3;

endmodule