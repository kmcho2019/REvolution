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

// Ripple subtractor
assign result[0] = A[0] - B[0];
assign borrow = (A[0] < B[0]);

assign result[1] = A[1] - B[1] - borrow;
wire borrow_1 = (A[1] < B[1]) || (A[1] == B[1] && borrow);

assign result[2] = A[2] - B[2] - borrow_1;
wire borrow_2 = (A[2] < B[2]) || (A[2] == B[2] && borrow_1);

assign result[3] = A[3] - B[3] - borrow_2;

// Determine the outputs
assign A_greater = (borrow_2 == 0) && (result != 4'b0000);
assign A_equal = (result == 4'b0000) && (borrow_2 == 0);
assign A_less = borrow_2;

endmodule