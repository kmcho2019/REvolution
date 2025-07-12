module comparator_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

// Internal wires to hold the result of subtraction and borrow
wire [3:0] result;
wire       borrow;

// Perform subtraction and generate borrow
assign {borrow, result} = A - B;

// Determine A_greater, A_equal, and A_less based on result and borrow
assign A_greater = (~borrow) & (|result);
assign A_equal   = (~borrow) & (~|result);
assign A_less    = borrow;

endmodule