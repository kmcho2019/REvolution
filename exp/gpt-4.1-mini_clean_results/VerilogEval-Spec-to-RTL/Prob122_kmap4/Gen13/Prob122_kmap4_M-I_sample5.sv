module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Directly assign the output to XOR of inputs for minimal logic
    assign out = a ^ b ^ c ^ d;

endmodule