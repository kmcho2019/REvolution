module comparator_3bit(
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] diff;
    wire       diff_zero;
    wire       diff_sign;

    // Perform subtraction A - B, extended to 4 bits to capture sign bit
    assign diff = {1'b0, A} - {1'b0, B};

    // Zero detection: all bits of diff are zero
    assign diff_zero = (diff == 4'b0000);

    // Sign bit of the result (MSB of diff)
    assign diff_sign = diff[3];

    // Determine outputs based on subtraction result
    assign A_equal   = diff_zero;
    assign A_greater = ~diff_sign & ~diff_zero;
    assign A_less    = diff_sign;

endmodule