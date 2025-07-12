module adder_bcd(
    input [3:0] A,  // First BCD input
    input [3:0] B,  // Second BCD input
    input Cin,      // Carry-in input
    output [3:0] Sum,  // 4-bit output representing the BCD sum
    output Cout      // Carry-out output
);

    // Perform binary addition
    wire [4:0] sum_bin = A + B + Cin;

    // Generate carry-out
    assign Cout = (sum_bin > 9) || (sum_bin[4]);

    // Apply BCD correction and ensure sum does not exceed 15
    assign Sum = (sum_bin <= 9)? sum_bin[3:0] : ((sum_bin[3:0] + 4'd6) & 4'd15);

endmodule