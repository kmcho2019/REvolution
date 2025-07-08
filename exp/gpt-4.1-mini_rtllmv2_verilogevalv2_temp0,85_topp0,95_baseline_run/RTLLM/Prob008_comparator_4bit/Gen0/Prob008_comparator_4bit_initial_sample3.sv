module comparator_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] diff;
    wire       borrow0, borrow1, borrow2, borrow3;

    // 1-bit subtractor: diff = A - B - borrow_in
    // borrow_out = (~A & (B | borrow_in)) | (B & borrow_in)

    assign {borrow0, diff[0]} = {1'b0, A[0]} - {1'b0, B[0]};
    assign {borrow1, diff[1]} = {borrow0, A[1]} - {1'b0, B[1]};
    assign {borrow2, diff[2]} = {borrow1, A[2]} - {1'b0, B[2]};
    assign {borrow3, diff[3]} = {borrow2, A[3]} - {1'b0, B[3]};

    // borrow3 is the final borrow-out: 1 means A < B
    // if borrow3 == 0 and diff != 0 then A > B
    // if diff == 0 then equal

    wire diff_zero = (diff == 4'b0000);

    assign A_less    = borrow3;
    assign A_equal   = (~borrow3) & diff_zero;
    assign A_greater = (~borrow3) & (~diff_zero);

endmodule