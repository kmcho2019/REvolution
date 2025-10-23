module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Directly assign output as parity of all four inputs
    assign out = a ^ b ^ c ^ d;

endmodule