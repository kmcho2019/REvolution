module comparator_4bit(
    input  [3:0] A,  // First 4-bit input operand
    input  [3:0] B,  // Second 4-bit input operand
    output reg     A_greater,  // 1-bit output indicating if A is greater than B
    output reg     A_equal,   // 1-bit output indicating if A is equal to B
    output reg     A_less     // 1-bit output indicating if A is less than B
    );

    // Perform subtraction A - B and generate borrow signal
    reg [4:0] diff;

    always @(*) begin
        diff = {1'b0, A} - {1'b0, B};

        // Assign output signals using logical operations
        // If most significant bit of diff is 1, it means A is less than B (borrow occurred)
        A_less = diff[4];
        
        // If no borrow and diff is not zero, A is greater than B
        A_greater = ~diff[4] & (|diff[3:0]);
        
        // If no borrow and diff is zero, A is equal to B
        A_equal = ~(diff[4] | |diff[3:0]);
    end

endmodule