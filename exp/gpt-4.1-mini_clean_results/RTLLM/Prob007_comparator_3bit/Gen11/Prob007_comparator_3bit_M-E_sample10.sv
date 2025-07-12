module comparator_3bit(
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // 4-bit difference with zero-extended inputs to detect borrow
    wire [3:0] diff = {1'b0, A} - {1'b0, B};

    // Check if difference is zero: all bits zero means A == B
    assign A_equal = (diff == 4'b0000);

    // The MSB of diff indicates sign: 0 means A >= B; 1 means A < B
    // Since A_equal covers equality, A_greater is true if diff > 0 (MSB=0 and not zero)
    assign A_greater = (~diff[3]) & (~A_equal);

    // A_less is true when MSB of diff is 1 (negative difference)
    assign A_less = diff[3];

endmodule