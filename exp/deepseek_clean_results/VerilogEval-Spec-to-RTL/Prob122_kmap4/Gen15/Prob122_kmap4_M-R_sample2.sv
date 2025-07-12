module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    /* Alternative implementation of checkerboard K-map pattern */
    wire ab_xor, cd_xor;
    
    assign ab_xor = a ^ b;
    assign cd_xor = c ^ d;
    assign out = ab_xor ^ cd_xor;

endmodule