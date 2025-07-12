module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    // Balanced XNOR tree for even parity, no intermediate wires for minimal nets
    assign q = ~((~(a ^ b)) ^ (~(c ^ d)));

endmodule