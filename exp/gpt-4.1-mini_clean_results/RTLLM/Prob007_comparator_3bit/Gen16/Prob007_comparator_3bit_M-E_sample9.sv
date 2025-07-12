module comparator_3bit(
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] diff_extended;  // 4-bit to detect sign easily

    // Extend inputs to 4 bits for subtraction to prevent wrap-around ambiguity
    assign diff_extended = {1'b0, A} - {1'b0, B};

    // Zero detection: all bits zero means equality
    assign A_equal = (diff_extended == 4'b0000);

    // Sign bit of diff_extended (MSB) determines if result is negative
    // If sign=0 and not zero -> A > B
    assign A_greater = ~diff_extended[3] & ~A_equal;

    // If sign=1 -> A < B
    assign A_less = diff_extended[3];

endmodule