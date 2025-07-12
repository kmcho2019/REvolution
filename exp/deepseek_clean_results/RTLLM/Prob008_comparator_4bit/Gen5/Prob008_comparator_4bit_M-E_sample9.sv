module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Generate thermometer codes
    wire [15:0] thermA, thermB;
    
    assign thermA = (16'b1 << A) - 1'b1;
    assign thermB = (16'b1 << B) - 1'b1;
    
    // Compare thermometer codes
    wire [15:0] gt_bits = thermA & ~thermB;
    wire [15:0] lt_bits = ~thermA & thermB;
    
    // Determine final outputs
    assign A_equal = (thermA == thermB);
    assign A_greater = |gt_bits;
    assign A_less = |lt_bits;

endmodule