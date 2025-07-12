module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Internal signals to store the borrow and result of subtraction
wire [3:0] result;
wire borrow;

// Perform subtraction A - B using full subtractors
assign result[0] = A[0] ^ B[0] ^ borrow;
assign result[1] = A[1] ^ B[1] ^ borrow;
assign result[2] = A[2] ^ B[2] ^ borrow;
assign result[3] = A[3] ^ B[3] ^ borrow;

// Generate borrow
assign borrow = (A[0] == 1'b0 && B[0] == 1'b1) || 
                (A[0] == 1'b0 && B[0] == 1'b0 && borrow) || 
                (A[1] == 1'b0 && B[1] == 1'b1 && borrow) || 
                (A[2] == 1'b0 && B[2] == 1'b1 && borrow) || 
                (A[3] == 1'b0 && B[3] == 1'b1 && borrow);

// Determine A_greater, A_equal, and A_less based on the result and borrow
assign A_greater = ~borrow && (|result); // A is greater than B if no borrow and result is non-zero
assign A_equal = ~borrow && ~( |result); // A is equal to B if no borrow and result is zero
assign A_less = borrow; // A is less than B if borrow occurs

endmodule