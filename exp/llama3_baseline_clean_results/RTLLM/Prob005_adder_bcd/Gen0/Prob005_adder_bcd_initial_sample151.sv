module adder_bcd(
    input [3:0] A,  // First BCD input
    input [3:0] B,  // Second BCD input
    input Cin,      // Carry-in input
    output [3:0] Sum,  // 4-bit output representing the sum of the two BCD inputs
    output Cout      // Carry-out output
);

    reg [4:0] binary_sum;  // Temporary variable to hold the binary sum of A, B, and Cin
    reg [3:0] temp_sum;    // Temporary variable to hold the sum before BCD correction
    reg [3:0] corrected_sum;  // Temporary variable to hold the sum after BCD correction

    // Perform binary addition of A, B, and Cin
    always @(A or B or Cin) begin
        binary_sum = (A + B + Cin);
        
        // Check if the binary sum exceeds 9 (1001 in binary)
        if (binary_sum > 9) begin
            // Apply BCD correction
            temp_sum = binary_sum[3:0] + 4'd6;  // Add 6 to the lower 4 bits of binary_sum
            corrected_sum = temp_sum;
        end else begin
            // No correction needed
            corrected_sum = binary_sum[3:0];
        end
        
        // Assign the final sum and carry-out
        Sum = corrected_sum[3:0];
        Cout = (binary_sum > 9) ? 1'b1 : 1'b0;
    end

endmodule