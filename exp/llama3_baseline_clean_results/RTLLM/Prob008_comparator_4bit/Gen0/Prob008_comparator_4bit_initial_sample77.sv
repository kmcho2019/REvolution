module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Perform subtraction and check for borrow
wire [3:0] result;
wire borrow;

assign {borrow, result} = A - B;

// Determine comparison outcome based on result and borrow
assign A_less = borrow;
assign A_equal = (~borrow) & (~|result); // result is zero and no borrow
assign A_greater = (~borrow) & (|result); // result is non-zero and no borrow

endmodule