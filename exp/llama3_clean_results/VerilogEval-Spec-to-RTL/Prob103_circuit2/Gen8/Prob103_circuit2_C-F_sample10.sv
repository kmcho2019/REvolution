module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// Directly compute the output q using XOR and inversion
assign q = ~(a ^ b ^ c ^ d);

endmodule