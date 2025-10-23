module TopModule (
    input [7:0] in,
    output parity
);
    // Optimal even parity calculation - XOR reduction of all input bits
    // This implementation provides:
    // - Minimum logic depth (best performance)
    // - Minimal gate count (best area)
    // - Least switching activity (best power)
    assign parity = ^in;
endmodule