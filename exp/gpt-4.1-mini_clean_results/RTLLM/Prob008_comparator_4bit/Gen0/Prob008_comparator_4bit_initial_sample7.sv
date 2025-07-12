module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] diff;
    wire       borrow0, borrow1, borrow2, borrow3;

    // Bit 0 subtraction with borrow_in = 0
    assign {borrow0, diff[0]} = {1'b0, A[0]} - B[0];
    // Bit 1 subtraction
    assign {borrow1, diff[1]} = {borrow0, A[1]} - B[1];
    // Bit 2 subtraction
    assign {borrow2, diff[2]} = {borrow1, A[2]} - B[2];
    // Bit 3 subtraction
    assign {borrow3, diff[3]} = {borrow2, A[3]} - B[3];

    // borrow3 indicates if A < B
    assign A_less    = borrow3;
    // If no borrow and diff is zero => equal
    assign A_equal   = ~borrow3 & (diff == 4'b0000);
    // If no borrow and diff != zero => A > B
    assign A_greater = ~borrow3 & (diff != 4'b0000);

endmodule