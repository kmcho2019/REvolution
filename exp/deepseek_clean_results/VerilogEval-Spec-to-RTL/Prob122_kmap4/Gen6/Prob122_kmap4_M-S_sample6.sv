module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

    wire ab_xor, cd_xor;
    
    xor(ab_xor, a, b);
    xor(cd_xor, c, d);
    xor(out, ab_xor, cd_xor);

endmodule