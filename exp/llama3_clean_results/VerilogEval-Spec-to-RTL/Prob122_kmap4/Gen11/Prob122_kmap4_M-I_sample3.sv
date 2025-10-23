module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Implementing the Karnaugh map logic using XOR operations
    // No changes needed, as the current implementation is already optimized
    assign out = (a ^ b) ^ (c ^ d);

endmodule