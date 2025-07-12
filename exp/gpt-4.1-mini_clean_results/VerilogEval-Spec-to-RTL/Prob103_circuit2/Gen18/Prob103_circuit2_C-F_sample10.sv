module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// Output q is high when the number of high inputs among a,b,c,d is even.
// Equivalently, q is the 4-input XNOR of a, b, c, d.
assign q = ~(a ^ b ^ c ^ d);

endmodule