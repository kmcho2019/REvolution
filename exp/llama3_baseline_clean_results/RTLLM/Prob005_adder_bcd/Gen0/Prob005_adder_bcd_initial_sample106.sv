module adder_bcd(
    input [3:0] A,  // First BCD input
    input [3:0] B,  // Second BCD input
    input Cin,     // Carry-in input
    output [3:0] Sum,  // 4-bit output representing the sum
    output Cout     // Carry-out output
);

// Perform binary addition of A, B, and Cin
wire [4:0] sum_temp;
assign sum_temp = A + B + Cin;

// Check if the sum exceeds 9 and apply correction if necessary
wire [3:0] sum_corrected;
assign sum_corrected = (sum_temp > 9) ? (sum_temp + 6) : sum_temp;

// Generate carry-out signal (Cout) if the result exceeds 9
assign Cout = (sum_temp > 9) || ((sum_temp + 6) > 9);

// Assign the corrected sum to the output (excluding the carry bit)
assign Sum = sum_corrected[3:0];

endmodule