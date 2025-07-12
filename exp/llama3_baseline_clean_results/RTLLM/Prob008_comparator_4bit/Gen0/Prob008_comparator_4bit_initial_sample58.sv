module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Internal wires for borrow and result
wire [3:0] result;
wire [3:0] borrow;

// Perform subtraction and generate borrow
assign {borrow[], result[3]} = A[3] - B[3];
assign {borrow[2], result[2]} = A - B[2] - borrow[3];
assign {borrow[1], result[1]} = A - B[1] - borrow[2];
assign {borrow[0], result[0]} = A[0] - B - borrow[];

// Determine A_greater, A_equal, and A_less
assign A_greater = ~borrow[0] & (|result);
assign A_equal = ~borrow[0] & ~(|result);
assign A_less = borrow[0];

endmodule