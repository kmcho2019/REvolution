module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] result;
    wire borrow;

    // Perform subtraction A - B and generate borrow
    assign {borrow, result} = A - B;

    // Determine if A is greater than B
    assign A_greater = (~borrow) && (|result); // If no borrow and result is non-zero

    // Determine if A is equal to B
    assign A_equal = (~borrow) && (~|result); // If no borrow and result is zero

    // Determine if A is less than B
    assign A_less = borrow; // If there's a borrow

endmodule