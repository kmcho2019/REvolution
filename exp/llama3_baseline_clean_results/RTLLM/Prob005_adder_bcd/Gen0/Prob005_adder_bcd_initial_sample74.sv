module adder_bcd(
    input [3:0] A,  // First BCD input
    input [3:0] B,  // Second BCD input
    input Cin,      // Carry-in input
    output [3:0] Sum,  // 4-bit output representing the sum of A and B, corrected to be a valid BCD digit
    output Cout      // Carry-out output
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] sum_bin = A + B + Cin;

    // Check if the sum exceeds 9 and correct it if necessary
    assign Sum = (sum_bin > 9) ? sum_bin + 6 : sum_bin[3:0];
    
    // Determine if a carry-out is needed
    assign Cout = (sum_bin > 9) ? 1'b1 : 1'b0;

endmodule