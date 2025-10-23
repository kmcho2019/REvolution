module adder_bcd(
    input  [3:0] A,  // First BCD input
    input  [3:0] B,  // Second BCD input
    input        Cin,  // Carry-in input
    output [3:0] Sum,  // 4-bit output representing the sum of the two BCD inputs
    output       Cout  // Carry-out output
);

    reg [4:0] temp_sum;  // Temporary variable to hold the sum of A, B, and Cin

    always @(A or B or Cin) begin
        temp_sum = A + B + Cin;  // Perform binary addition
        
        // Apply BCD correction if sum exceeds 9
        if (temp_sum > 9) begin
            temp_sum = temp_sum + 6;  // Add 6 for BCD correction
            Cout = 1'b1;  // Set carry-out if result exceeds 9
        end else begin
            Cout = 1'b0;  // Reset carry-out if result is within 0-9
        end

        // Assign the lower 4 bits of temp_sum to Sum
        Sum = temp_sum[3:0];
    end

endmodule