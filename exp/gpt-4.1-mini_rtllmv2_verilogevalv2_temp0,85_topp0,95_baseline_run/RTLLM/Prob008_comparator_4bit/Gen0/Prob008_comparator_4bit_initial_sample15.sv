module comparator_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] diff;
    wire       borrow0, borrow1, borrow2, borrow3;

    // Bit 0 subtractor
    assign {borrow0, diff[0]} = {1'b0, A[0]} - B[0];
    // Bit 1 subtractor
    assign {borrow1, diff[1]} = {borrow0, A[1]} - B[1];
    // Bit 2 subtractor
    assign {borrow2, diff[2]} = {borrow1, A[2]} - B[2];
    // Bit 3 subtractor
    assign {borrow3, diff[3]} = {borrow2, A[3]} - B[3];

    wire result_zero = (diff == 4'b0000);

    assign A_less    = borrow3;                  // borrow out means A < B
    assign A_equal   = (~borrow3) & result_zero; // no borrow and zero result means equal
    assign A_greater = (~borrow3) & ~result_zero;// no borrow and non-zero means A > B

endmodule