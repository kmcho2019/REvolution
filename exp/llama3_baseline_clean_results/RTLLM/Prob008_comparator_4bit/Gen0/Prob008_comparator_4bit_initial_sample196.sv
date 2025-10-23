module comparator_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

// Perform subtraction A - B
wire [3:0] diff;
wire       borrow;

// Subtract B from A
assign diff[0] = A[0] - B[0];
assign borrow = (A[0] < B[0])? 1 : 0;
assign diff[1] = A[1] - B[1] - borrow;
assign borrow = (A[1] < (B[1] + borrow))? 1 : 0;
assign diff[2] = A[2] - B[2] - borrow;
assign borrow = (A[2] < (B[2] + borrow))? 1 : 0;
assign diff[3] = A[3] - B[3] - borrow;

// Determine the relationship between A and B based on the result of subtraction
assign A_less = (borrow == 1)? 1 : 0;
assign A_equal = (~|diff) & (~borrow); // A is equal to B if the result of subtraction is zero and no borrow occurred
assign A_greater = ~(A_equal | A_less); // A is greater than B if it is neither less than nor equal to B

endmodule