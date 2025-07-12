module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Implementing the Karnaugh map logic using XOR operations
    // The current implementation is correct and efficient
    assign out = (a ^ b) ^ (c ^ d);

endmodule