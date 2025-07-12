module adder_bcd(
    input [3:0] A,  // First BCD input
    input [3:0] B,  // Second BCD input
    input Cin,     // Carry-in input
    output [3:0] Sum,  // 4-bit output representing the BCD sum
    output Cout     // Carry-out output
);

// Intermediate wires for the sum and carry
wire [4:0] temp_sum;  // Binary sum of A, B, and Cin

// Perform binary addition of A, B, and Cin
assign temp_sum = {1'b0, A} + {1'b0, B} + {4'b0000, Cin};

// Determine the carry-out based on the sum exceeding 9
assign Cout = (temp_sum > 4'd9) ? 1'b1 : 1'b0;

// Apply BCD correction if sum exceeds 9
assign Sum = (temp_sum > 4'd9) ? (temp_sum + 4'd6)[3:0] : temp_sum[3:0];

endmodule