module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    wire xor_ab, xor_cd, xor_abcd;
    assign xor_ab = a ^ b;
    assign xor_cd = c ^ d;
    assign xor_abcd = xor_ab ^ xor_cd;
    assign q = ~xor_abcd;
endmodule