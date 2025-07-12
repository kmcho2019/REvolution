module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Internal wires to store the result of subtraction
    wire [3:0] result;
    wire borrow;

    // Perform subtraction using a ripple borrow subtractor
    assign {borrow, result[3:0]} = A - B;

    // Determine if A is greater than B
    assign A_greater = (~borrow) & (|result);

    // Determine if A is equal to B
    assign A_equal = (~borrow) & ~( |result );

    // Determine if A is less than B
    assign A_less = borrow;

endmodule