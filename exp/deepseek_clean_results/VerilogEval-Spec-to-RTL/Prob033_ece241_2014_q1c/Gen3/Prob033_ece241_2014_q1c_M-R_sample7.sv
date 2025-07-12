module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    wire [7:0] a_ext = {a[7], a[6:0]};  // Explicit sign extension
    wire [7:0] b_ext = {b[7], b[6:0]};
    wire [8:0] sum = {1'b0, a_ext} + {1'b0, b_ext};  // 9-bit addition
    
    assign s = sum[7:0];
    
    // Overflow occurs when signs are same but result sign differs
    assign overflow = ~(a[7] ^ b[7]) & (a[7] ^ s[7]);
endmodule