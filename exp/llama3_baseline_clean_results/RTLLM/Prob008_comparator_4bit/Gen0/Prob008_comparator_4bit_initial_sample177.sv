module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

// internal wires for subtraction result and borrow
wire [3:0] diff;
wire borrow;

// Perform subtraction: A - B
assign {borrow, diff[3:0]} = A - B;

// A is less than B if a borrow occurred
assign A_less = borrow;

// A is equal to B if no borrow and result is zero
assign A_equal = (~borrow) & (~|diff);

// A is greater than B if no borrow and result is non-zero
assign A_greater = (~borrow) & (|diff);

endmodule