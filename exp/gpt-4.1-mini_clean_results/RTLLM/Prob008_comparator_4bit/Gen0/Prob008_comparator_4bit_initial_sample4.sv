module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

// Internal wires for difference bits and borrows
wire [3:0] diff;
wire       borrow0, borrow1, borrow2, borrow3;

// Full subtractor for bit 0
assign diff[0]   = A[0] ^ B[0] ^ 1'b0;                     // difference bit 0
assign borrow0   = (~A[0] & B[0]) | ((~A[0] | B[0]) & 1'b0); // borrow from bit 0 with borrow_in = 0

// Full subtractor for bit 1
assign diff[1]   = A[1] ^ B[1] ^ borrow0;
assign borrow1   = (~A[1] & B[1]) | ((~A[1] | B[1]) & borrow0);

// Full subtractor for bit 2
assign diff[2]   = A[2] ^ B[2] ^ borrow1;
assign borrow2   = (~A[2] & B[2]) | ((~A[2] | B[2]) & borrow1);

// Full subtractor for bit 3
assign diff[3]   = A[3] ^ B[3] ^ borrow2;
assign borrow3   = (~A[3] & B[3]) | ((~A[3] | B[3]) & borrow2);

// Determine outputs
wire result_zero = (diff == 4'b0000);

assign A_less    = borrow3;                    // borrow out from MSB means A < B
assign A_equal   = (~borrow3) & result_zero;  // no borrow and difference zero means equal
assign A_greater = (~borrow3) & (~result_zero); // no borrow and difference non-zero means A > B

endmodule