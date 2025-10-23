/**
 * 8-bit Ripple Carry Adder - Compact Implementation
 * Same functionality as original but with more concise syntax
 * Maintains optimized carry computation using majority function
 */
module adder_8bit (
    input [7:0] a,     // 8-bit operand A
    input [7:0] b,     // 8-bit operand B
    input cin,         // Carry-in
    output [7:0] sum,  // 8-bit sum output
    output cout       // Carry-out
);

    // Intermediate carry signals
    wire [7:0] c;
    
    // Bit 0 computation
    assign {c[0], sum[0]} = a[0] + b[0] + cin;
    
    // Bits 1-6 computation
    assign {c[1], sum[1]} = a[1] + b[1] + c[0];
    assign {c[2], sum[2]} = a[2] + b[2] + c[1];
    assign {c[3], sum[3]} = a[3] + b[3] + c[2];
    assign {c[4], sum[4]} = a[4] + b[4] + c[3];
    assign {c[5], sum[5]} = a[5] + b[5] + c[4];
    assign {c[6], sum[6]} = a[6] + b[6] + c[5];
    
    // Bit 7 computation (carry-out)
    assign {cout, sum[7]} = a[7] + b[7] + c[6];

endmodule