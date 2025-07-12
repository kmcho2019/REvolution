module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

assign out = (in1 == in2) ^ in3;

// Alternatively, using XOR and NOR operators directly for clarity
// assign xnor_out = ~(in1 ^ in2); // Implementing XNOR using XOR and NOT
// assign out = xnor_out ^ in3;

endmodule