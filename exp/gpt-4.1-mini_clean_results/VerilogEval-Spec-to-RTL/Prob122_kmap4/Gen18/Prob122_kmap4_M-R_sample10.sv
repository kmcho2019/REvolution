module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Directly assign the XOR of all inputs as output
    assign out = a ^ b ^ c ^ d;

endmodule