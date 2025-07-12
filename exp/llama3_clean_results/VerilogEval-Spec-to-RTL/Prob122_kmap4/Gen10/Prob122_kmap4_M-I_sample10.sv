module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // The current implementation is already optimized for the given Karnaugh map.
    // However, we can try to simplify it further or use equivalent logic.
    assign out = (a ^ b) ^ (c ^ d);

    // Alternatively, we could express the logic using other operations, but
    // given the nature of the Karnaugh map, XOR operations seem the most direct.
    // assign out = ((a ^ b) ^ (c ^ d)); // This is the same as the current implementation.

endmodule