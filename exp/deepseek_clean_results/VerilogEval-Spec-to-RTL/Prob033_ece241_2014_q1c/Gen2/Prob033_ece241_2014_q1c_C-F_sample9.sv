module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Direct sum assignment (concise like Example 1)
    assign s = a + b;
    
    // Clear overflow conditions (well-commented like Example 2)
    assign overflow = (~a[7] & ~b[7] & s[7]) |  // Positive + Positive = Negative
                     (a[7] & b[7] & ~s[7]);     // Negative + Negative = Positive
endmodule