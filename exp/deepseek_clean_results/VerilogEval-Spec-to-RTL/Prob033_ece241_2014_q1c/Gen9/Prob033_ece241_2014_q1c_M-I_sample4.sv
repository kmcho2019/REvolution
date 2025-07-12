module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    wire [8:0] sum = {1'b0, a} + {1'b0, b};
    assign s = sum[7:0];
    
    // Optimized overflow detection
    wire signs_differ = a[7] ^ b[7];
    assign overflow = ~signs_differ & (a[7] ^ s[7]);
endmodule