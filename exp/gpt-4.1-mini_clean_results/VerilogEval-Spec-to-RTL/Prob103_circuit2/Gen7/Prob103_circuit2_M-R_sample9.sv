module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    wire xor_abcd;
    assign xor_abcd = a ^ b ^ c ^ d;
    assign q = ~xor_abcd;
endmodule