module adder_bcd(
    input [3:0] A,  // First BCD input
    input [3:0] B,  // Second BCD input
    input Cin,      // Carry-in input
    output [3:0] Sum,  // 4-bit output representing the sum
    output Cout      // Carry-out output
);

// Intermediate wires for calculation
wire [4:0] sum_raw;  // Raw sum before correction
wire [4:0] sum_corrected;  // Sum after correction

// Perform binary addition of A, B, and Cin
assign sum_raw = A + B + Cin;

// Check if correction is needed and apply it
assign sum_corrected = (sum_raw > 9) ? sum_raw + 6 : sum_raw;

// Assign the corrected sum to the output
assign Sum = sum_corrected[3:0];

// Generate carry-out if the corrected sum exceeds 9
assign Cout = (sum_corrected > 9) ? 1'b1 : (sum_raw > 9) ? 1'b1 : 1'b0;

endmodule