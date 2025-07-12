module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    // q = 1 if parity(a,b) == parity(c,d), else 0
    assign q = ~((a ^ b) ^ (c ^ d));
endmodule