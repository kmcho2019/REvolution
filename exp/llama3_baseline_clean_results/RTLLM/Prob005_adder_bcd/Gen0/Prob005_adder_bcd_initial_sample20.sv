module adder_bcd(
    input [3:0] A, // First BCD input
    input [3:0] B, // Second BCD input
    input Cin,     // Carry-in input
    output [3:0] Sum, // 4-bit output representing the BCD sum
    output Cout     // Carry-out output
);

// Temporary variable to hold the initial binary sum
reg [4:0] temp_sum;

// Perform binary addition of A, B, and Cin
assign temp_sum = A + B + Cin;

// Apply BCD correction if the sum exceeds 9
always @(*) begin
    if (temp_sum > 9) begin
        Sum = temp_sum + 6;
        Cout = 1'b1; // Generate carry-out
    end else begin
        Sum = temp_sum[3:0]; // Assign the lower 4 bits to Sum
        Cout = 1'b0; // No carry-out
    end
end

endmodule