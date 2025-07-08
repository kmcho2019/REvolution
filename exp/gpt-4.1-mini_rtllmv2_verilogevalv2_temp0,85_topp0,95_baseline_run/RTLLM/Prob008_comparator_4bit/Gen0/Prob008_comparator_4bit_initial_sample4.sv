module comparator_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

// Internal wires for borrow and difference bits
wire [3:0] diff;
wire       borrow0, borrow1, borrow2, borrow3;

// Bit 0 subtractor: A[0] - B[0] - borrow_in(0)
assign {borrow0, diff[0]} = {1'b0, A[0]} - B[0];

// Bit 1 subtractor: A[1] - B[1] - borrow0
assign {borrow1, diff[1]} = {1'b0, A[1]} - B[1] - borrow0;

// Bit 2 subtractor: A[2] - B[2] - borrow1
assign {borrow2, diff[2]} = {1'b0, A[2]} - B[2] - borrow1;

// Bit 3 subtractor: A[3] - B[3] - borrow2
assign {borrow3, diff[3]} = {1'b0, A[3]} - B[3] - borrow2;

// Determine outputs based on borrow3 and diff result
assign A_less    = borrow3;
assign A_equal   = (~borrow3) & (diff == 4'b0000);
assign A_greater = (~borrow3) & (diff != 4'b0000);

endmodule