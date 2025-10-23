module adder_bcd(
    input [3:0] A,  // First BCD input
    input [3:0] B,  // Second BCD input
    input Cin,     // Carry-in input
    output [3:0] Sum,  // 4-bit output representing the BCD sum
    output Cout    // Carry-out output
);

// Intermediate signals for the sum of A, B, and Cin
wire [4:0] sum_bin;

// Binary addition of A, B, and Cin
assign sum_bin = {1'b0, A} + {1'b0, B} + {4{Cin}};

// Correction signal: 1 if sum exceeds 9 (binary 1001), 0 otherwise
wire correction_needed;
assign correction_needed = sum_bin[4] | (sum_bin[3:0] == 4'b1000);

// Apply correction if needed
wire [3:0] correction_value;
assign correction_value = (correction_needed) ? 4'b0110 : 4'b0000;

// Final sum after applying correction
wire [4:0] final_sum;
assign final_sum = sum_bin + {1'b0, correction_value};

// Assign outputs
assign Sum = final_sum[3:0];
assign Cout = correction_needed;

endmodule