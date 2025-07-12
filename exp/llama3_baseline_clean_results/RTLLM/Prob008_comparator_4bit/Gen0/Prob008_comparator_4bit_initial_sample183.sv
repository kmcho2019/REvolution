module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Internal wires for borrow and result
wire [3:0] result;
wire borrow;

// Perform subtraction A - B
assign result[0] = A[0] - B[0];
assign borrow = (A[0] < B[0])? 1 : 0;

assign result[1] = A[1] - B[1] - borrow;
assign borrow = (A[1] < (B[1] + borrow))? 1 : 0;

assign result[2] = A[2] - B[2] - borrow;
assign borrow = (A[2] < (B[2] + borrow))? 1 : 0;

assign result[3] = A[3] - B[3] - borrow;

// Determine the output signals based on the result and borrow
assign A_greater = (~borrow) & (~(|result));
assign A_equal = ~( |result );
assign A_less = borrow;

endmodule