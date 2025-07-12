module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Perform signed addition with proper sign extension
    wire [8:0] sum = {a[7], a} + {b[7], b};
    assign s = sum[7:0];
    
    // Optimized overflow detection:
    // Overflow occurs when signs of inputs are equal but result sign differs
    assign overflow = ~(a[7] ^ b[7]) & (a[7] ^ sum[7]);
endmodule