module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Ripple-carry adder using continuous assignment
    assign s = a + b;
    
    // Optimized overflow detection
    wire signs_differ = a[7] ^ b[7];
    assign overflow = ~signs_differ & (a[7] ^ s[7]);
endmodule