module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// Even parity function using reduction XNOR operator (~^)
// q = 1 when number of '1's in inputs is even.
assign q = ~^(a, b, c, d);

endmodule