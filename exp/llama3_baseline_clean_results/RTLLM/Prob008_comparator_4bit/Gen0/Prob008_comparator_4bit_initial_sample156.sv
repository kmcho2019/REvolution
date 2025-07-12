module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Perform bit-level subtraction
wire [3:0] diff;
wire borrow;

// Subtract B from A
assign diff[0] = A[0] ^ B[0] ^ borrow;
assign diff[1] = A[1] ^ B[1] ^ borrow;
assign diff[2] = A[2] ^ B[2] ^ borrow;
assign diff[3] = A[3] ^ B[3] ^ borrow;

// Generate borrow
assign borrow = (A[0] == 1'b0 && B[0] == 1'b1) || 
               (A[1] == 1'b0 && B[1] == 1'b1 && A[0] == B[0]) || 
               (A[2] == 1'b0 && B[2] == 1'b1 && A[1:0] == B[1:0]) || 
               (A[3] == 1'b0 && B[3] == 1'b1 && A[2:0] == B[2:0]);

// Determine A_greater
assign A_greater = ~borrow && (diff != 4'b0000);

// Determine A_equal
assign A_equal = ~borrow && (diff == 4'b0000);

// Determine A_less
assign A_less = borrow;

endmodule