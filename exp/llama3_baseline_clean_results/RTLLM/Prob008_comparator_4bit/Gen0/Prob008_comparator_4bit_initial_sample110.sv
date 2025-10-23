module comparator_4bit(
    input [3:0] A,  // First 4-bit input operand
    input [3:0] B,  // Second 4-bit input operand
    output reg A_greater,  // Output indicating if A is greater than B
    output reg A_equal,   // Output indicating if A is equal to B
    output reg A_less     // Output indicating if A is less than B
);

    // Perform subtraction A - B and generate borrow
    wire [3:0] diff;
    wire borrow;

    // Subtraction operation A - B with borrow
    assign {borrow, diff} = A - B;

    // Determine comparison result based on difference and borrow
    always @(*) begin
        if (borrow) begin  // If borrow occurs, A is less than B
            A_greater = 1'b0;
            A_equal = 1'b0;
            A_less = 1'b1;
        end else if (diff == 4'b0) begin  // If result is zero, A is equal to B
            A_greater = 1'b0;
            A_equal = 1'b1;
            A_less = 1'b0;
        end else begin  // If no borrow and result is non-zero, A is greater than B
            A_greater = 1'b1;
            A_equal = 1'b0;
            A_less = 1'b0;
        end
    end

endmodule