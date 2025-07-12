module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Direct assignment of sum
    assign s = a + b;
    
    // Input sign indicators
    wire a_positive = ~a[7];
    wire b_positive = ~b[7];
    wire a_negative = a[7];
    wire b_negative = b[7];
    wire sum_positive = ~s[7];
    wire sum_negative = s[7];
    
    // Overflow conditions
    wire positive_overflow = a_positive & b_positive & sum_negative;
    wire negative_overflow = a_negative & b_negative & sum_positive;
    
    // Final overflow assignment
    assign overflow = positive_overflow | negative_overflow;
endmodule