module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    assign q = ~ (a ^ b ^ c ^ d); // Even parity output computed in a single expression

endmodule