module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Thermometer code conversion
    wire [14:0] therm_A, therm_B;
    
    assign therm_A = (15'b1 << A) - 1'b1;
    assign therm_B = (15'b1 << B) - 1'b1;

    // Comparison logic
    wire [14:0] gt_bits = therm_A & ~therm_B;
    wire [14:0] lt_bits = ~therm_A & therm_B;
    
    assign A_equal = (therm_A == therm_B);
    assign A_greater = |gt_bits;
    assign A_less = |lt_bits;

endmodule