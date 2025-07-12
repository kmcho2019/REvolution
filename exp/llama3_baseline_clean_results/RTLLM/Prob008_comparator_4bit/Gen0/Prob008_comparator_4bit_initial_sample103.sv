module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Perform subtraction A - B and analyze the result and borrow
wire [3:0] result;
wire borrow;

// Subtraction logic with borrow
assign result[0] = A[0] - B[0];
assign borrow = (A[0] < B[0]);
assign result[1] = A[1] - B[1] - borrow;
assign borrow = (A[1] < B[1] + borrow);
assign result[2] = A[2] - B[2] - borrow;
assign borrow = (A[2] < B[2] + borrow);
assign result[3] = A[3] - B[3] - borrow;

// Output logic
assign A_greater = (~borrow) && (|result); // A is greater if no borrow and result is not zero
assign A_equal = ~(|result); // A is equal if result is zero
assign A_less = borrow; // A is less if borrow occurred

endmodule