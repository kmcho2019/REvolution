module comparator_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Direct comparison for simplicity and efficiency
    assign A_equal = (A == B) ? 1'b1 : 1'b0;

    // Manual comparison logic for better control over PPA metrics
    // Compare bits from MSB to LSB
    wire [3:0] diff;
    assign diff = A - B;

    // Indicates A > B if no borrow and result is not zero
    assign A_greater = (diff[3] == 1'b0 && diff != 4'b0000) ? 1'b1 : 1'b0;

    // Indicates A < B if borrow occurred
    assign A_less    = (diff[3] == 1'b1) ? 1'b1 : 1'b0;

    // Alternatively, for simplicity and compiler optimization:
    // assign A_greater = (A > B) ? 1'b1 : 1'b0;
    // assign A_less    = (A < B) ? 1'b1 : 1'b0;

endmodule