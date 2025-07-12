module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    // Compute even parity by XORing all inputs and inverting the result
    assign q = ~(a ^ b ^ c ^ d);

endmodule