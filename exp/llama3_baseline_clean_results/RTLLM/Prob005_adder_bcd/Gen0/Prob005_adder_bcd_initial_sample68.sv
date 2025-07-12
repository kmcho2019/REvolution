module adder_bcd (
    input [3:0] A,  // First BCD input
    input [3:0] B,  // Second BCD input
    input Cin,      // Carry-in input
    output [3:0] Sum,  // 4-bit output representing the sum
    output Cout      // Carry-out output
);

    // Temporary variable to hold the sum of A, B, and Cin
    reg [4:0] temp_sum;

    // Perform binary addition of A, B, and Cin
    always @(A or B or Cin) begin
        temp_sum = A + B + Cin;
        
        // Check if the sum exceeds 9 (which is 1001 in binary)
        if (temp_sum > 4'd9) begin
            // Add 6 (0110 in binary) to correct the sum to a valid BCD digit
            Sum = (temp_sum + 4'd6)[3:0];
            // Generate carry-out if the corrected sum still exceeds 9
            Cout = 1'b1;
        end else begin
            // If the sum does not exceed 9, directly assign the sum
            Sum = temp_sum[3:0];
            // No carry-out needed
            Cout = 1'b0;
        end
    end

endmodule