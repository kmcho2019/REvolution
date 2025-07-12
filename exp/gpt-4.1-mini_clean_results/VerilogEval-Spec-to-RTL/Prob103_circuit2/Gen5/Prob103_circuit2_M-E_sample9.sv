module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

assign q = ~(a ^ b ^ c ^ d); // even parity: XNOR of all inputs

endmodule