module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Internal signals for borrow and result of subtraction
wire borrow_0, borrow_1, borrow_2, borrow_3;
wire [3:0] result;

// Full subtractor for each bit position
assign {borrow_0, result[0]} = A[0] - B[0];
assign {borrow_1, result[1]} = A[1] - B[1] - borrow_0;
assign {borrow_2, result[2]} = A[2] - B[2] - borrow_1;
assign {borrow_3, result[3]} = A[3] - B[3] - borrow_2;

// Determine the final output based on the borrow and result of subtraction
assign A_greater = ~borrow_3 & (~result[3] & ~result[2] & ~result[1] & ~result[0]);
assign A_equal = ~borrow_3 & (result[3] & result[2] & result[1] & result[0]);
assign A_less = borrow_3;

endmodule