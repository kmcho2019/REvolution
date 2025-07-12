module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Internal signals for borrow and result
wire [3:0] result;
wire [3:0] borrow;

// Full subtractor for each bit position
assign {borrow[0], result[0]} = A[0] - B[0];
assign {borrow[1], result[1]} = A[1] - B[1] + ~borrow[0];
assign {borrow[2], result[2]} = A[2] - B[2] + ~borrow[1];
assign {borrow[3], result[3]} = A[3] - B[3] + ~borrow[2];

// Encoding outputs based on borrow and result signals
assign A_greater = ~borrow[3] & (|result); // A is greater if no borrow and result is non-zero
assign A_equal = ~borrow[3] & ~(|result); // A is equal if no borrow and result is zero
assign A_less = borrow[3]; // A is less if borrow occurs

endmodule