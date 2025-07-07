module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] diff;
    wire       borrow0, borrow1, borrow2, borrow3;

    // Bit 0 subtraction: A[0] - B[0] - borrow_in(0)
    assign {borrow0, diff[0]} = {1'b0, A[0]} - {1'b0, B[0]};

    // Bit 1 subtraction: A[1] - B[1] - borrow0
    assign {borrow1, diff[1]} = {1'b0, A[1]} - {1'b0, B[1]} - borrow0;

    // Bit 2 subtraction: A[2] - B[2] - borrow1
    assign {borrow2, diff[2]} = {1'b0, A[2]} - {1'b0, B[2]} - borrow1;

    // Bit 3 subtraction: A[3] - B[3] - borrow2
    assign {borrow3, diff[3]} = {1'b0, A[3]} - {1'b0, B[3]} - borrow2;

    // borrow3 is the final borrow out: 1 means A < B
    assign A_less = borrow3;

    // If no borrow and diff is zero, A == B
    assign A_equal = (~borrow3) & (diff == 4'b0000);

    // If no borrow and diff != 0, A > B
    assign A_greater = (~borrow3) & (diff != 4'b0000);

endmodule