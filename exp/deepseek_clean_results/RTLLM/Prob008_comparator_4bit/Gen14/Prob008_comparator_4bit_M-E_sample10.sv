module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Generate difference vector
    wire [3:0] diff = A ^ B;
    wire [3:0] gt_bit = A & ~B;

    // Thermometer-encoded comparison
    wire gt3 = gt_bit[3];
    wire gt2 = diff[3] ? 1'b0 : gt_bit[2];
    wire gt1 = (|diff[3:2]) ? 1'b0 : gt_bit[1];
    wire gt0 = (|diff[3:1]) ? 1'b0 : gt_bit[0];

    // Final comparison results
    wire any_gt = gt3 | gt2 | gt1 | gt0;
    wire all_eq = ~(|diff);

    assign A_greater = any_gt;
    assign A_equal = all_eq;
    assign A_less = ~all_eq & ~any_gt;

endmodule