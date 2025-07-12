module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Implementing the Karnaugh map logic using XOR operations
    // The current implementation is correct and efficient
    // For optimization, considering the inputs are stable before evaluation
    // and exploring library-specific optimizations for XOR operations if applicable
    assign out = (a ^ b) ^ (c ^ d);

    // No significant changes are made as the current implementation is efficient
    // and the PPA metrics show very low power consumption and area usage

endmodule