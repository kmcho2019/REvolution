module comparator_3bit(
    input  wire [2:0] A,
    input  wire [2:0] B,
    output wire       A_greater,
    output wire       A_equal,
    output wire       A_less
);

    // Perform subtraction with one extra bit for sign detection
    wire [3:0] diff = {1'b0, A} - {1'b0, B};

    // Equality: if diff == 0
    assign A_equal = (diff == 4'b0000);

    // If MSB (sign bit) of diff is 1, then A < B; else A >= B
    assign A_less = diff[3];

    // If not less and not equal, A must be greater
    assign A_greater = ~A_less & ~A_equal;

endmodule