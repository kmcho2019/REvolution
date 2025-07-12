module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    // Even parity: output 1 when an even number of inputs are 1
    assign q = ~^(a ^ b ^ c ^ d);

endmodule