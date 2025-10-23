module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    wire ab_xor;
    wire cd_xor;
    
    assign ab_xor = a ^ b;
    assign cd_xor = c ^ d;
    // q is 1 if ab_xor equals cd_xor (XNOR)
    assign q = ~(ab_xor ^ cd_xor);
endmodule