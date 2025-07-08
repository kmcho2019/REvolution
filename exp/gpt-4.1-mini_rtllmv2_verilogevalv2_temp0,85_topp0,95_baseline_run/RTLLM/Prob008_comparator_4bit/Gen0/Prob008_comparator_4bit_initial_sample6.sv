module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);
    wire [3:0] diff;
    wire       borrow0, borrow1, borrow2, borrow3;

    // Subtract bit 0: A[0] - B[0]
    assign {borrow0, diff[0]} = {1'b0, A[0]} - B[0];

    // Subtract bit 1: A[1] - B[1] - borrow0
    assign {borrow1, diff[1]} = {1'b0, A[1]} - B[1] - borrow0;

    // Subtract bit 2: A[2] - B[2] - borrow1
    assign {borrow2, diff[2]} = {1'b0, A[2]} - B[2] - borrow1;

    // Subtract bit 3: A[3] - B[3] - borrow2
    assign {borrow3, diff[3]} = {1'b0, A[3]} - B[3] - borrow2;

    // borrow3 is the final borrow; if 1, A < B
    assign A_less = borrow3;

    // Check if result is zero
    wire diff_zero = (diff == 4'b0000);

    // If no borrow and diff zero, A == B
    assign A_equal = (~borrow3) & diff_zero;

    // If no borrow and diff non-zero, A > B
    assign A_greater = (~borrow3) & ~diff_zero;

endmodule