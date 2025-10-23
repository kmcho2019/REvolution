module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

    wire xor_ab = a ^ b;
    wire xor_cd = c ^ d;
    
    assign out = xor_ab ^ xor_cd;

endmodule