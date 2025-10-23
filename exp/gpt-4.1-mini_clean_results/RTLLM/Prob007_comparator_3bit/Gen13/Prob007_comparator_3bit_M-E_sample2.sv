module comparator_3bit(
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] diff;  // 4-bit to hold difference including borrow/underflow

    // Implement combinational subtraction: diff = A - B
    // Using full subtractor chain implemented with arithmetic expression
    assign diff = {1'b0, A} - {1'b0, B};

    // If diff == 0, then A == B
    wire zero = (diff[2:0] == 3'b000);

    // Borrow-out indicates if A < B (if diff[3] == 1)
    wire borrow = diff[3];

    assign A_equal   = zero;
    assign A_less    = borrow;
    assign A_greater = ~zero & ~borrow;

endmodule