module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// Calculate the output q based on the parity of the inputs
assign q = ~(a ^ b ^ c ^ d);

endmodule