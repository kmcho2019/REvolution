module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Output is the parity of all four inputs
    assign out = a ^ b ^ c ^ d;
endmodule