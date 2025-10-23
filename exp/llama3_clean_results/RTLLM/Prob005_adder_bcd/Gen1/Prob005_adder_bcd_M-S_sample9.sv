module adder_bcd(
    input [3:0] A,  // First BCD input
    input [3:0] B,  // Second BCD input
    input Cin,      // Carry-in input
    output [3:0] Sum,  // 4-bit output representing the BCD sum
    output Cout      // Carry-out output
);

    // Calculate the binary sum of A, B, and Cin
    wire [4:0] bin_sum = A + B + Cin;

    // Apply BCD correction and generate carry-out
    assign Sum = (bin_sum > 9) ? (bin_sum[3:0] + 6) : bin_sum[3:0];
    assign Cout = (bin_sum > 9) ? 1'b1 : 1'b0;

endmodule