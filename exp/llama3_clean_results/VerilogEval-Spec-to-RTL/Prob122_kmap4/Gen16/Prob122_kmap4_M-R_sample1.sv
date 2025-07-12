module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Implementing the Karnaugh map logic by comparing XOR results
    assign out = ((a ^ b) == (c ^ d)) ? 1'b1 : 1'b0;

endmodule