module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    
    // Directly compute q using a single logical operation
    assign q = ~(a ^ b ^ c ^ d);
    
endmodule