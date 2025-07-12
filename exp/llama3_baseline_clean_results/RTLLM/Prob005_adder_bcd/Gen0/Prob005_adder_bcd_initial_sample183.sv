module adder_bcd(
    input [3:0] A,  // First BCD input
    input [3:0] B,  // Second BCD input
    input Cin,      // Carry-in input
    output [3:0] Sum,  // 4-bit output representing the BCD sum
    output Cout      // Carry-out output
);

// Perform binary addition of A, B, and Cin
reg [4:0] sum_temp;  // Temporary sum (5 bits to handle carry)
assign sum_temp = A + B + Cin;

// Apply BCD correction if sum exceeds 9
reg [4:0] corrected_sum;  // Sum after applying BCD correction
assign corrected_sum = (sum_temp > 9)? sum_temp + 6 : sum_temp;

// Assign corrected sum and carry-out
assign Sum = corrected_sum[3:0];  // Assign the lower 4 bits of the corrected sum
assign Cout = corrected_sum[4];  // Carry-out is the MSB of the corrected sum

endmodule