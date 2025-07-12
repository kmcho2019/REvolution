module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    
    // Directly compute q as the inverse of the XOR of a, b, c, and d
    assign q = ~(a ^ b ^ c ^ d);
    
endmodule