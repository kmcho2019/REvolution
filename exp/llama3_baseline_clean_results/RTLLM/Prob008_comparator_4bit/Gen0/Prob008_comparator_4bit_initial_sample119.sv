module comparator_4bit (
    input   [3:0] A,
    input   [3:0] B,
    output  A_greater,
    output  A_equal,
    output  A_less
);

    // Internal signals to hold the borrow and result of subtraction
    wire    [3:0] result;
    wire    [3:0] borrow;

    // Full subtractor for each bit position
    assign  {borrow[0], result[0]} = A[0] - B[0];
    assign  {borrow[1], result[1]} = A[1] - B[1] - borrow[0];
    assign  {borrow[2], result[2]} = A[2] - B[2] - borrow[1];
    assign  {borrow[3], result[3]} = A[3] - B[3] - borrow[2];

    // Determine the final output based on the borrow and result
    assign  A_greater = ~(borrow[3]) & (~(|result)); // No borrow and result is not zero (non-zero in two's complement means MSB is 1)
    assign  A_equal   = ~(borrow[3]) & (|result) == 1'b0; // No borrow and result is zero (all bits are zero)
    assign  A_less    = borrow[3]; // Borrow indicates A is less than B

endmodule