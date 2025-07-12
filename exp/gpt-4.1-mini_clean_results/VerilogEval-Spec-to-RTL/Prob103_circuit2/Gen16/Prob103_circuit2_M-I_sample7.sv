module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// q = NOT (a XOR b XOR c XOR d)
assign q = ~(a ^ b ^ c ^ d);

endmodule