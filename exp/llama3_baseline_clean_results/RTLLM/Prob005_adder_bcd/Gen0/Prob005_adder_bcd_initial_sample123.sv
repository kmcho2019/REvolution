module adder_bcd(
    input [3:0] A,  // First BCD input
    input [3:0] B,  // Second BCD input
    input Cin,     // Carry-in input
    output [3:0] Sum,  // 4-bit output representing the BCD sum
    output Cout     // Carry-out output
);

// Temporary variable to hold the binary sum of A, B, and Cin
reg [4:0] bin_sum;

// Perform binary addition of A, B, and Cin
always @(*) begin
    bin_sum = A + B + Cin;

    // Apply BCD correction if the sum exceeds 9
    if (bin_sum > 9) begin
        Sum = bin_sum + 6;
        Cout = 1;  // Generate carry-out
    end else begin
        Sum = bin_sum[3:0];  // Assign the lower 4 bits of bin_sum to Sum
        Cout = 0;  // No carry-out
    end
end

endmodule