module comparator_3bit(
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Extend A and B to 4 bits by zero-extending to prevent overflow
    wire [3:0] A_ext = {1'b0, A};
    wire [3:0] B_ext = {1'b0, B};

    // Compute 4-bit difference: A_ext - B_ext
    wire [3:0] diff = A_ext - B_ext;

    // Check if diff is zero: all bits zero
    wire diff_zero = (diff == 4'b0000);

    // Check if diff is positive: MSB=0 and not zero
    wire diff_positive = (diff[3] == 1'b0) && (~diff_zero);

    // If diff is negative: MSB=1
    wire diff_negative = (diff[3] == 1'b1);

    // Assign outputs accordingly
    assign A_equal   = diff_zero;
    assign A_greater = diff_positive;
    assign A_less    = diff_negative;

endmodule