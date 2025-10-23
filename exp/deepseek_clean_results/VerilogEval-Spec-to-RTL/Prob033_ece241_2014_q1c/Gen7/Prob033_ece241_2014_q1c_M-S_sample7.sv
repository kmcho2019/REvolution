module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Perform direct 8-bit addition
    assign s = a + b;
    
    // Simplified overflow detection
    assign overflow = ~(a[7] ^ b[7]) & (a[7] ^ s[7]);
endmodule