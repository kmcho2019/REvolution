module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Simple ripple-carry addition
    assign s = a + b;
    
    // Efficient overflow detection for signed numbers
    assign overflow = ~(a[7] ^ b[7]) & (a[7] ^ s[7]);
endmodule