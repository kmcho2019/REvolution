module comparator_3bit(
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Perform subtraction A - B, extended to 4 bits to capture sign
    wire signed [3:0] diff = {1'b0, A} - {1'b0, B};

    // Check if difference is zero
    assign A_equal   = (diff == 0);

    // If difference is positive, A > B
    assign A_greater = (diff > 0);

    // Otherwise, A < B
    assign A_less    = (diff < 0);

endmodule