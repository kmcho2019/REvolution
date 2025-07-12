module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Directly XOR all inputs to produce output
    assign out = a ^ b ^ c ^ d;
endmodule