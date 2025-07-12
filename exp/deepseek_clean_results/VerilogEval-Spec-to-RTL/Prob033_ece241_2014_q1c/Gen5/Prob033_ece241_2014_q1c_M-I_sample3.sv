module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    wire sign_match = ~(a[7] ^ b[7]);  // 1 when signs match
    
    assign s = a + b;
    
    // Optimized overflow detection:
    // sign_match AND result sign differs from inputs
    assign overflow = sign_match & (a[7] ^ s[7]);
endmodule