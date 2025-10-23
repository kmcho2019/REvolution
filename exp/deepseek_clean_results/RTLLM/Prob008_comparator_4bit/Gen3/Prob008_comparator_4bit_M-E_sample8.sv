module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Bit-wise comparison signals
wire [3:0] bit_greater;
wire [3:0] bit_equal;
wire [3:0] bit_less;

// Generate comparison for each bit
assign bit_greater = A & ~B;
assign bit_less = ~A & B;
assign bit_equal = ~(A ^ B);

// Priority encoder logic
wire [3:0] priority_mask = {4{1'b1}};
wire [3:0] diff_pos;

// Find first position where bits differ
assign diff_pos = (A ^ B) & priority_mask;
assign priority_mask[3] = bit_equal[3];
assign priority_mask[2] = bit_equal[3] & bit_equal[2];
assign priority_mask[1] = bit_equal[3] & bit_equal[2] & bit_equal[1];
assign priority_mask[0] = 1'b0; // LSB doesn't need masking

// Final outputs
assign A_greater = |(bit_greater & diff_pos);
assign A_equal = &bit_equal;
assign A_less = |(bit_less & diff_pos);

endmodule