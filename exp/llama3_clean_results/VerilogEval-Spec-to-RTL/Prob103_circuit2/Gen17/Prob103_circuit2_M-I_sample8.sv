module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    
    // Directly compute q using a single logical operation
    // The existing implementation is already quite minimal and efficient.
    assign q = ~(a ^ b ^ c ^ d);
    
endmodule