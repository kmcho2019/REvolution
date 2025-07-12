module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Direct balanced XOR tree for parity function without intermediate wires
    assign out = (a ^ b) ^ (c ^ d);

endmodule