module comparator_4bit(
    input [3:0] A,  // First 4-bit input operand
    input [3:0] B,  // Second 4-bit input operand
    output reg A_greater,  // 1-bit output indicating if A is greater than B
    output reg A_equal,   // 1-bit output indicating if A is equal to B
    output reg A_less     // 1-bit output indicating if A is less than B
);

// Perform subtraction A - B and check for borrow
reg [3:0] result;
reg borrow;
always @(*) begin
    {borrow, result} = A - B;

    // Determine the outputs based on the result and borrow
    if (borrow) begin
        A_less = 1'b1;  // If borrow occurs, A is less than B
        A_greater = 1'b0;
        A_equal = 1'b0;
    end else if (result == 4'b0) begin
        A_equal = 1'b1;  // If result is zero, A is equal to B
        A_greater = 1'b0;
        A_less = 1'b0;
    end else begin
        A_greater = 1'b1;  // If no borrow and result is non-zero, A is greater than B
        A_equal = 1'b0;
        A_less = 1'b0;
    end
end

endmodule