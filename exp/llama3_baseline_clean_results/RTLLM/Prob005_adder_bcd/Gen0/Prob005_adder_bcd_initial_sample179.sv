module adder_bcd(
    input [3:0] A,  // First 4-bit BCD input
    input [3:0] B,  // Second 4-bit BCD input
    input Cin,     // Carry-in input
    output [3:0] Sum,  // 4-bit output representing the sum of A and B in BCD
    output Cout      // Carry-out output
);

// Temporary variable to hold the binary sum of A, B, and Cin
reg [4:0] binary_sum;

// Perform binary addition of A, B, and Cin
always @(*) begin
    binary_sum = A + B + Cin;
end

// Apply BCD correction and generate carry-out
always @(*) begin
    if (binary_sum > 9) begin
        // Apply BCD correction by adding 6 to the sum
        Sum = binary_sum + 6;
        // Generate carry-out
        Cout = 1'b1;
    end else begin
        Sum = binary_sum[3:0];  // Assign the lower 4 bits of binary_sum to Sum
        Cout = 1'b0;
    end
end

endmodule