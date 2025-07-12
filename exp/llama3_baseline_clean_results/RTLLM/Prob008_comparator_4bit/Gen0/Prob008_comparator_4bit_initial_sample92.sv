module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Perform subtraction A - B and generate a 5-bit result (including borrow)
wire [4:0] result;
assign result = {1'b0, A} - {1'b0, B};

// Check for borrow (A is less than B)
assign A_less = result[4];

// Check for no borrow and non-zero result (A is greater than B)
assign A_greater = ~result[4] & ~(|result[3:0]);

// Check for zero result (A is equal to B)
assign A_equal = ~(result[4] | |result[3:0]);

endmodule