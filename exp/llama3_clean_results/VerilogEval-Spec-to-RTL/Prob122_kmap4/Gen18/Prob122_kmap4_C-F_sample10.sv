module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Directly implement the Karnaugh map logic using XOR operations
    assign out = a ^ b ^ c ^ d;

endmodule