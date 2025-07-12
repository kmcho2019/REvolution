module adder_bcd(
    input [3:0] A,  // First BCD input
    input [3:0] B,  // Second BCD input
    input Cin,      // Carry-in input
    output [3:0] Sum,  // 4-bit output representing the sum
    output Cout       // Carry-out output
);

    // Temporary variable to hold the sum of A, B, and Cin
    reg [4:0] temp_sum;

    always @(*) begin
        // Perform binary addition of A, B, and Cin
        temp_sum = A + B + Cin;
        
        // If the sum exceeds 9 (1001 in binary), apply correction
        if (temp_sum > 9) begin
            // Add 6 (0110 in binary) to the sum for correction
            Sum = temp_sum + 6;
            // Generate carry-out since the result exceeds a single decimal digit
            Cout = 1;
        end else begin
            // If sum does not exceed 9, directly assign it to Sum
            Sum = temp_sum[3:0];  // Only take the lower 4 bits
            // No carry-out since the result is within a single decimal digit
            Cout = 0;
        end
    end

endmodule