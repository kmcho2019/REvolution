module comparator_4bit(
    input [3:0] A,  // First 4-bit input operand
    input [3:0] B,  // Second 4-bit input operand
    output A_greater,  // 1-bit output indicating if A is greater than B
    output A_equal,    // 1-bit output indicating if A is equal to B
    output A_less      // 1-bit output indicating if A is less than B
);

// Perform subtraction and generate output
wire [4:0] result;  // 5-bit result (4-bit result + 1-bit borrow)
assign result = {1'b0, A} - {1'b0, B};

// Determine outputs based on result and borrow
assign A_greater = (result[4] == 0 && result[3:0] != 0);
assign A_equal = (result[3:0] == 0 && result[4] == 0);
assign A_less = result[4];

endmodule