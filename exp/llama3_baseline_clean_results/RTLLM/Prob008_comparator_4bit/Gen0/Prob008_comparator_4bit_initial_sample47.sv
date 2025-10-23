module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Perform subtraction (A - B) and generate borrow flag
    wire [3:0] result;
    wire borrow;

    assign {borrow, result} = A - B;

    // Set output signals based on borrow flag and result of subtraction
    assign A_greater = ~borrow & (|result); // A_greater if no borrow and result of subtraction is non-zero
    assign A_equal = ~borrow & ~( |result); // A_equal if no borrow and result of subtraction is zero
    assign A_less = borrow; // A_less if borrow occurs during subtraction

endmodule