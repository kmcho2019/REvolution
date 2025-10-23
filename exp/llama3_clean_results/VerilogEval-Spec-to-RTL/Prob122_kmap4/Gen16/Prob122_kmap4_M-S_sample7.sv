module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Simplified implementation of the Karnaugh map logic
    assign out = (a ^ b) ^ (c ^ d);

endmodule