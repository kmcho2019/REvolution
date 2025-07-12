module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    // Directly compute even parity by inverting XOR of all inputs
    assign q = ~(a ^ b ^ c ^ d);

endmodule