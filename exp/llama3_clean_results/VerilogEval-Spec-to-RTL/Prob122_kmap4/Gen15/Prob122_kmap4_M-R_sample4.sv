module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Directly assign the XOR operation to the output
    assign out = a ^ b ^ c ^ d;

endmodule