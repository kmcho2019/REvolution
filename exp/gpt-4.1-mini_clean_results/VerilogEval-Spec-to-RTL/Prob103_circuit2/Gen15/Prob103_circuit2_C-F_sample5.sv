module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// q is 1 when the number of inputs set to 1 is even (even parity)
assign q = ~(a ^ b ^ c ^ d);

endmodule