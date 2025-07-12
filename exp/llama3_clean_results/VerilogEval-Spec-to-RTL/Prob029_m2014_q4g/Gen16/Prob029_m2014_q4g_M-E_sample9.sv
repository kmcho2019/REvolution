module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// Compute the output directly using AND, OR, and NOT gates
assign out = ((in1 & in2) | (~in1 & ~in2)) ^ in3;

// Alternative implementation using a different combination of gates
// assign out = ~(in1 ^ in2) ^ in3;

endmodule