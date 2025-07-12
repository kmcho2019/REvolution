module adder_bcd(
    input [3:0] A,  // First BCD input
    input [3:0] B,  // Second BCD input
    input Cin,     // Carry-in input
    output [3:0] Sum,  // 4-bit output representing the BCD sum
    output Cout     // Carry-out output
);

    // Temporary variable to hold the binary sum of A, B, and Cin
    reg [4:0] temp_sum;

    // Perform binary addition
    always @(A or B or Cin) begin
        temp_sum = A + B + Cin;

        // Check if the sum exceeds 9 and apply BCD correction if necessary
        if (temp_sum > 9) begin
            // Apply BCD correction by adding 6
            Sum = temp_sum + 6;
            // Generate carry-out since the sum exceeds 9
            Cout = 1'b1;
        end else begin
            // No correction needed, assign the sum directly
            Sum = temp_sum[3:0];  // Take the lower 4 bits
            // No carry-out since the sum does not exceed 9
            Cout = 1'b0;
        end
    end

endmodule