module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Directly assign output as XOR of all inputs
    assign out = a ^ b ^ c ^ d;

endmodule