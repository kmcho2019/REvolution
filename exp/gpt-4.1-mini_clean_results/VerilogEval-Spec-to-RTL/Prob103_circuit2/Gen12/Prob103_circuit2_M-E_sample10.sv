module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    wire ab_parity;
    wire cd_parity;
    
    assign ab_parity = a ^ b;  // parity of first two bits
    assign cd_parity = c ^ d;  // parity of last two bits
    assign q = ~(ab_parity ^ cd_parity); // output high for even parity
    
endmodule