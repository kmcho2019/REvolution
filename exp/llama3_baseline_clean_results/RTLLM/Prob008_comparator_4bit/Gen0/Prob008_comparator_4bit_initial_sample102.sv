module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Perform subtraction A - B using a ripple borrow subtractor
wire [3:0] diff;
wire borrow;

// Calculate the difference and borrow
assign diff[0] = A[0] - B[0];
assign borrow[0] = (A[0] < B[0])? 1 : 0;

assign diff[1] = A[1] - B[1] - borrow[0];
assign borrow[1] = (A[1] < B[1] + borrow[0])? 1 : 0;

assign diff[2] = A[2] - B[2] - borrow[1];
assign borrow[2] = (A[2] < B[2] + borrow[1])? 1 : 0;

assign diff[3] = A[3] - B[3] - borrow[2];
assign borrow[3] = (A[3] < B[3] + borrow[2])? 1 : 0;

// Determine the relationship between A and B
assign A_greater = (~borrow[3] && (diff[3] || diff[2] || diff[1] || diff[0]));
assign A_equal = (~borrow[3] && ~diff[3] && ~diff[2] && ~diff[1] && ~diff[0]);
assign A_less = borrow[3];

endmodule