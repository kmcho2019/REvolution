module comparator_3bit(
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Perform subtraction: A - B
    wire [3:0] diff = {1'b0, A} - {1'b0, B}; // 4-bit to capture borrow/sign

    // diff[3] is MSB of 4-bit diff; if 1, result negative (A < B)
    // If diff == 0, A == B
    // Else, A > B

    assign A_equal   = (diff == 4'b0000);
    assign A_less    = diff[3];                // Negative result indicates A < B
    assign A_greater = (~diff[3]) & (~A_equal);

endmodule