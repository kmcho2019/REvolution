module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Perform subtraction A - B
    wire [3:0] result;
    wire borrow;

    assign result = A - B;
    assign borrow = (A < B) ? 1'b1 : 1'b0;

    // Determine output signals
    assign A_greater = (~borrow) & (|result);
    assign A_equal = ~(borrow | |result);
    assign A_less = borrow;

endmodule