module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Internal wires to hold the borrow and result of subtraction
    wire [3:0] result;
    wire borrow_out;

    // Perform subtraction A - B
    assign {borrow_out, result[3:0]} = A - B;

    // Determine the outputs based on the borrow and result
    assign A_greater = (borrow_out == 1'b0) && (result != 4'b0000);
    assign A_equal = (borrow_out == 1'b0) && (result == 4'b0000);
    assign A_less = borrow_out;

endmodule