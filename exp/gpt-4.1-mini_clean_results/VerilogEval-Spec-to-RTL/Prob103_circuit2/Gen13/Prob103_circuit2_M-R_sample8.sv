module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// q is 1 if the number of inputs set to 1 is even, else 0
assign q = ~(a ^ b ^ c ^ d);

endmodule