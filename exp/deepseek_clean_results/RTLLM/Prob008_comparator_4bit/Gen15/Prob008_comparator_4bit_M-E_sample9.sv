module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Find bit positions where A and B differ
    wire [3:0] diff = A ^ B;

    // Create mask for most significant differing bit
    wire msb_diff = diff[3];
    wire [2:0] lower_diff = diff[2:0] & {3{~msb_diff}};
    
    wire [1:0] mask = {msb_diff, |lower_diff[2:1]};
    wire [0:0] final_mask = {|lower_diff[0]} & {1{~|mask}};
    
    wire [3:0] priority_mask = {msb_diff, mask[1], mask[0], final_mask};

    // Determine comparison result at MSB difference
    wire A_gt_at_diff = |(A & priority_mask);
    wire A_lt_at_diff = |(B & priority_mask);

    // Output assignments
    assign A_equal = ~|diff;
    assign A_greater = ~A_equal & A_gt_at_diff;
    assign A_less = ~A_equal & A_lt_at_diff;

endmodule