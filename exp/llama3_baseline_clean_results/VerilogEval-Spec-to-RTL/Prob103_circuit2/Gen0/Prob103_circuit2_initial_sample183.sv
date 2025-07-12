module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
    );

assign q = ~(a ^ b ^ c ^ d); // Inverting the result of XORing all inputs to get even parity check

endmodule