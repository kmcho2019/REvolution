module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire b0, b1, b2, b3;
    wire [3:0] diff;

    // Ripple borrow subtraction: A - B
    // b0 = borrow from bit 0 subtraction, initial borrow in = 0
    assign {b0, diff[0]} = {1'b0, A[0]} - B[0];
    assign {b1, diff[1]} = {b0, A[1]} - B[1];
    assign {b2, diff[2]} = {b1, A[2]} - B[2];
    assign {b3, diff[3]} = {b2, A[3]} - B[3];

    // If borrow out (b3) is 1, A < B
    assign A_less = b3;

    // Equality: all bits equal means diff is zero
    wire all_zero = ~(diff[0] | diff[1] | diff[2] | diff[3]);
    assign A_equal = all_zero;

    // A_greater when not less and not equal
    assign A_greater = ~(A_less | A_equal);

endmodule