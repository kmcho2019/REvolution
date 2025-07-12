module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Subtraction result and flags
wire [4:0] diff = {1'b0, A} - {1'b0, B};
wire borrow = diff[4];  // Sign bit indicates borrow
wire zero = (diff[3:0] == 4'b0);

// Output assignments - mutually exclusive
assign A_equal = zero;
assign A_greater = ~zero & ~borrow;
assign A_less = ~zero & borrow;

endmodule