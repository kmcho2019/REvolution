module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// Internal wires for the XNOR gate
wire xnor_out;

// XNOR gate implementation using AND, OR, and NOT gates
assign xnor_out = (in1 & in2) | ~(in1 | in2);

// Internal wires for the XOR gate
wire xor_out1, xor_out2;

// XOR gate implementation using AND, OR, and NOT gates
assign xor_out1 = xnor_out & ~in3;
assign xor_out2 = ~xnor_out & in3;

// Final output of the XOR gate
assign out = xor_out1 | xor_out2;

endmodule