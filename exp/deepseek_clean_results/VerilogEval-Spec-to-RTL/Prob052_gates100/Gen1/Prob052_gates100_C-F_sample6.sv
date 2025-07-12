module TopModule (
    input [99:0] in,       // 100-bit input vector
    output out_and,        // 1 if ALL inputs are 1
    output out_or,         // 1 if ANY input is 1
    output out_xor         // 1 if ODD number of inputs are 1
);

    // Reduction operations on the 100-bit input
    assign out_and = &in;  // 100-input AND (all bits high)
    assign out_or  = |in;  // 100-input OR (any bit high)
    assign out_xor = ^in;  // 100-input XOR (odd parity)

endmodule