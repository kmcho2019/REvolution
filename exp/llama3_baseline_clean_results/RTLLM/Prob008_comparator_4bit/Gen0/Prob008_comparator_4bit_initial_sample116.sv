module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Perform subtraction: A - B. If a borrow occurs, A is less than B.
// We use a temporary wire for the borrow output.
wire borrow;
wire [3:0] diff;

// Assuming a full subtractor for each bit position is not the goal here,
// but rather understanding the overall operation.
assign diff[0] = A[0] ? (B[0] ? 1'b0 : 1'b1) : (B[0] ? 1'b1 : 1'b0);
assign diff[1] = A[1] ? (B[1] ? 1'b0 : 1'b1) : (B[1] ? (A[0] ? 1'b1 : 1'b0) : 1'b0);
assign diff[2] = A[2] ? (B[2] ? 1'b0 : 1'b1) : (B[2] ? (A[1] ? 1'b1 : (A[0] ? 1'b1 : 1'b0)) : 1'b0);
assign diff[3] = A[3] ? (B[3] ? 1'b0 : 1'b1) : (B[3] ? (A[2] ? 1'b1 : (A[1] ? 1'b1 : (A[0] ? 1'b1 : 1'b0))) : 1'b0);

// If a borrow occurs at any point, A is less than B.
assign borrow = (A[0] == 0 && B[0] == 1) || 
               (A[1] == 0 && B[1] == 1 && (A[0] == 1)) || 
               (A[2] == 0 && B[2] == 1 && ((A[1] == 1) || (A[0] == 1))) || 
               (A[3] == 0 && B[3] == 1 && ((A[2] == 1) || (A[1] == 1) || (A[0] == 1)));

assign A_greater = (~borrow && (diff != 4'b0000));
assign A_equal = (diff == 4'b0000 && ~borrow);
assign A_less = borrow;

endmodule