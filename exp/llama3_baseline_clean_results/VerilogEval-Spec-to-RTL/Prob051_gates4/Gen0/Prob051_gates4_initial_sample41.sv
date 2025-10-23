module TopModule(
    input  [3:0] in,  // 4-bit input vector
    output out_and,   // Output of 4-input AND gate
    output out_or,    // Output of 4-input OR gate
    output out_xor    // Output of 4-input XOR gate
);

// Reduction AND (&) gives output 1 only if all inputs are 1
assign out_and = &in;

// Reduction OR (|) gives output 1 if any input is 1
assign out_or = |in;

// Reduction XOR (^) gives output 1 if an odd number of inputs are 1
assign out_xor = ^in;

endmodule