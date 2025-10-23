module comparator_4bit(
    input  [3:0] A,  // First 4-bit input operand
    input  [3:0] B,  // Second 4-bit input operand
    output reg     A_greater,  // 1-bit output indicating if A is greater than B
    output reg     A_equal,   // 1-bit output indicating if A is equal to B
    output reg     A_less     // 1-bit output indicating if A is less than B
    );

    // Perform subtraction A - B and generate borrow signal
    reg [3:0] diff;
    reg borrow;

    always @(*) begin
        {borrow, diff[3:0]} = A - B;

        // Determine A_greater, A_equal, and A_less based on the result of subtraction
        if (borrow) begin
            A_greater = 1'b0;
            A_equal = 1'b0;
            A_less = 1'b1;
        end else if (diff == 4'b0000) begin
            A_greater = 1'b0;
            A_equal = 1'b1;
            A_less = 1'b0;
        end else begin
            A_greater = 1'b1;
            A_equal = 1'b0;
            A_less = 1'b0;
        end
    end

endmodule