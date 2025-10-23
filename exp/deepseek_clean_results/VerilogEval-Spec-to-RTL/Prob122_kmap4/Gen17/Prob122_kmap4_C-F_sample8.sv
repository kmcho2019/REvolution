module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    /* Checkerboard pattern implementation:
       out = 1 when parity of ab matches parity of cd
       Equivalent to (a XOR b) XOR (c XOR d) */
    assign out = (a ^ b) ^ (c ^ d);

endmodule