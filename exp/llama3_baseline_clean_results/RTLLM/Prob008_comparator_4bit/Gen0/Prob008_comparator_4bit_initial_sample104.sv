module comparator_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

// Perform subtraction operation A - B and detect borrow
wire [3:0] result;
wire       borrow;

// Use full subtractors to perform subtraction
assign {borrow, result[0]} = A[0] - B[0];
assign {result[1]} = A[1] - B[1] - borrow;
assign {result[2]} = A[2] - B[2] - borrow;
assign {result[3]} = A[3] - B[3] - borrow;

// Determine outputs based on result and borrow
assign A_greater = ~borrow & ~(|result);  // Set high when A is greater than B
assign A_equal   = ~borrow &  (|result);  // Set high when A is equal to B
assign A_less    = borrow;                // Set high when A is less than B

endmodule