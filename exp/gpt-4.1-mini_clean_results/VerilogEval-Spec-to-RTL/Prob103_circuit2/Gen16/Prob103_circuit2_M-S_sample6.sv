module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    // Compute even parity by XOR'ing inputs and then inverting the result
    assign q = ~(a ^ b ^ c ^ d);

endmodule