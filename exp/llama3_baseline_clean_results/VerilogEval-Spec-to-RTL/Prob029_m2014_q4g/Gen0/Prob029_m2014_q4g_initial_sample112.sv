module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// Create an internal signal for the output of the XNOR gate
wire xnor_out;

// Implement the XNOR gate using the equality operator (==)
assign xnor_out = ~(in1 ^ in2);

// Implement the XOR gate using the XOR operator (^)
assign out = xnor_out ^ in3;

endmodule