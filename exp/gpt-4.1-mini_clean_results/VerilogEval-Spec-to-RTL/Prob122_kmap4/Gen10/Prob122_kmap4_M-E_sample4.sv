module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Chain XOR all inputs in a sequence, implementing parity.
    // out = (((a ^ b) ^ c) ^ d)
    assign out = a ^ b ^ c ^ d;
endmodule