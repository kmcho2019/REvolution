module comparator_3bit(
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Compute difference A - B as a 4-bit signed value
    wire [3:0] diff = {1'b0, A} - {1'b0, B};

    // Equality if difference is zero
    assign A_equal = (diff == 4'b0000);

    // If difference MSB (sign bit) is 0 and not zero, A > B
    assign A_greater = (~diff[3]) & (~A_equal);

    // If difference MSB (sign bit) is 1, A < B
    assign A_less = diff[3];

endmodule