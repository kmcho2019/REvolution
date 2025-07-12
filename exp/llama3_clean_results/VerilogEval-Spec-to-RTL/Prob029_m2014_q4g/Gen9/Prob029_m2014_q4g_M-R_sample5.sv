module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

wire xnor_out;  // Intermediate signal for XNOR operation
wire xor_out;   // Intermediate signal for XOR operation

assign xnor_out = ~(in1 ^ in2);  // XNOR operation
assign xor_out = xnor_out ^ in3; // XOR operation
assign out = xor_out;            // Final output

endmodule