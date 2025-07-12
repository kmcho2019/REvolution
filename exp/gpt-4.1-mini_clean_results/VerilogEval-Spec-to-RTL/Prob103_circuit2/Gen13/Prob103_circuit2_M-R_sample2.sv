module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// q = 1 if number of 1's in inputs is even, else 0
assign q = ~(a ^ b ^ c ^ d);

endmodule