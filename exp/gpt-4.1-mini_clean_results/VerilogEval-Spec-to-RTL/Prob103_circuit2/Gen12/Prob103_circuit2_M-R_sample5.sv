module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// Compute even parity: q=1 when even number of inputs are 1
assign q = ~(a ^ b ^ c ^ d);

endmodule