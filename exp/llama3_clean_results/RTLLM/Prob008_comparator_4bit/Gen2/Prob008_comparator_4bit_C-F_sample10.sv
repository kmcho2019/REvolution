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
        {borrow, diff} = A - B;

        // Assign output signals using logical operations
        A_greater = (~borrow) & (|diff);
        A_equal = ~(borrow | |diff);
        A_less = borrow;
    end

endmodule