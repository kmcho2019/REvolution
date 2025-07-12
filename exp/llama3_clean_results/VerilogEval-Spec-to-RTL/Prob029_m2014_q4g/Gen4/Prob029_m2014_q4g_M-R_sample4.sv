module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// Refactored computation using XOR properties
assign out = ~(in1 ^ in2) ^ in3;

endmodule