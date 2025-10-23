module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // The logic is already simplified and correctly implements the Karnaugh map.
    // Further optimizations would depend on specific synthesis and technology constraints.
    assign out = a ^ b ^ c ^ d;

endmodule