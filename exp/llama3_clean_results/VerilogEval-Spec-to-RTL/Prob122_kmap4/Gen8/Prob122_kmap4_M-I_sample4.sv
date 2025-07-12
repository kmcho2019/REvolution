module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // The current implementation is already optimized for the given Karnaugh map.
    // We maintain the same logic to ensure correctness and simplicity.
    assign out = (a ^ b) ^ (c ^ d);

endmodule