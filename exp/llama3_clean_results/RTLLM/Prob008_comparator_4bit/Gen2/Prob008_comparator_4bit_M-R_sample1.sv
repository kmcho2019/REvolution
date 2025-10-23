module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

// Define the wires for the full subtractor outputs
wire [3:0] diff;
wire [3:0] borrow;

// Use full subtractors for each bit position
assign diff[0] = A[0] - B[0];
assign borrow[0] = (A[0] < B[0]) ? 1 : 0;

assign diff[1] = A[1] - B[1] - borrow[0];
assign borrow[1] = (A[1] - borrow[0] < B[1]) ? 1 : 0;

assign diff[2] = A[2] - B[2] - borrow[1];
assign borrow[2] = (A[2] - borrow[1] < B[2]) ? 1 : 0;

assign diff[3] = A[3] - B[3] - borrow[2];
assign borrow[3] = (A[3] - borrow[2] < B[3]) ? 1 : 0;

// Determine A_greater, A_equal, A_less based on the result of the subtraction
assign A_greater = (~borrow[3]) & (|diff);
assign A_equal = (~|diff);
assign A_less = borrow[3];

endmodule