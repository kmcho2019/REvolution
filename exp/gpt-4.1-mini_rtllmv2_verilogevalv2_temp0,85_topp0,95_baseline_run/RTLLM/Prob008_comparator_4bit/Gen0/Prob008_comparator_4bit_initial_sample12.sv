module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] diff;
    wire       borrow_out;

    // Perform A - B with borrow chain
    wire b0, b1, b2;

    // Bit 0 subtraction
    assign {b0, diff[0]} = {1'b0, A[0]} - B[0];
    // Bit 1 subtraction
    assign {b1, diff[1]} = {b0, A[1]} - B[1];
    // Bit 2 subtraction
    assign {b2, diff[2]} = {b1, A[2]} - B[2];
    // Bit 3 subtraction
    assign {borrow_out, diff[3]} = {b2, A[3]} - B[3];

    // borrow_out = 1 means A < B
    assign A_less    = borrow_out;
    // diff == 0 means A == B (and no borrow)
    assign A_equal   = (~borrow_out) & (diff == 4'b0000);
    // no borrow and diff != 0 means A > B
    assign A_greater = (~borrow_out) & (diff != 4'b0000);

endmodule