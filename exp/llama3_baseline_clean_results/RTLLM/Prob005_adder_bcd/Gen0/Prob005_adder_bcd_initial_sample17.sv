module adder_bcd(
    input [3:0] A,  // First BCD input
    input [3:0] B,  // Second BCD input
    input Cin,     // Carry-in input
    output [3:0] Sum,  // 4-bit output representing the sum of the two BCD inputs
    output Cout     // Carry-out output
);

// Perform binary addition of A, B, and Cin
wire [4:0] sum_binary = A + B + Cin;

// Check if the sum exceeds 9 (binary 1001)
wire [3:0] sum_corrected;
wire Cout_temp;

// If the sum exceeds 9, add 6 (binary 0110) to correct it
assign sum_corrected = (sum_binary > 9) ? (sum_binary + 6) : sum_binary;
assign Cout_temp = (sum_binary > 9) ? 1'b1 : 1'b0;

// Extract the lower 4 bits of the corrected sum
assign Sum = sum_corrected[3:0];
assign Cout = Cout_temp;

endmodule