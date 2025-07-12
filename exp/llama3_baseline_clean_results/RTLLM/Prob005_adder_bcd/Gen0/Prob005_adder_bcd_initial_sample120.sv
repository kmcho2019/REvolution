module adder_bcd(
    input [3:0] A,  // First BCD input
    input [3:0] B,  // Second BCD input
    input Cin,     // Carry-in input
    output [3:0] Sum,  // 4-bit output representing the sum of the two BCD inputs
    output Cout     // Carry-out output
);

// Perform binary addition of A, B, and Cin
wire [4:0] binary_sum;
assign binary_sum = A + B + Cin;

// Check if the sum exceeds 9 and apply correction if needed
reg [3:0] corrected_sum;
always @(binary_sum) begin
    if (binary_sum > 9) begin
        corrected_sum = binary_sum + 6;
    end else begin
        corrected_sum = binary_sum[3:0];
    end
end

// Assign the corrected sum to the output Sum
assign Sum = corrected_sum;

// Generate carry-out (Cout) if the result exceeds 9 or if the original sum exceeds 9
assign Cout = (binary_sum > 9) || (binary_sum + 6 > 9);

endmodule