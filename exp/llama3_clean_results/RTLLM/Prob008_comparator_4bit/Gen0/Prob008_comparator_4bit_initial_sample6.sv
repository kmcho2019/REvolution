module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Perform subtraction and generate borrow
wire [3:0] result;
wire borrow;

// Assign the result and borrow
assign result = A - B;
assign borrow = (A[0] < B[0]) || ((A[0] == B[0]) && (A[1] < B[1])) || ((A[0:1] == B[0:1]) && (A[2] < B[2])) || ((A[0:2] == B[0:2]) && (A[3] < B[3]));

// Determine the outputs based on the result and borrow
assign A_greater = ~borrow && (result != 0);
assign A_equal = ~borrow && (result == 0);
assign A_less = borrow;

endmodule