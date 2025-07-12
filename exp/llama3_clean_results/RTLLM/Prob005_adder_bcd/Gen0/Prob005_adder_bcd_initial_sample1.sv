module adder_bcd(
    input [3:0] A,  // First BCD input
    input [3:0] B,  // Second BCD input
    input Cin,      // Carry-in input
    output [3:0] Sum,  // 4-bit output representing the BCD sum
    output Cout      // Carry-out output
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] bin_sum;
    assign bin_sum = A + B + Cin;

    // Check if the binary sum exceeds 9 (1001 in binary)
    wire [3:0] sum_out;
    assign sum_out = (bin_sum > 9)? (bin_sum + 6) : bin_sum;

    // Generate carry-out if the sum exceeds 9
    assign Cout = (bin_sum > 9)? 1'b1 : 1'b0;

    // Assign the corrected sum to the output port
    assign Sum = (sum_out > 15)? sum_out[3:0] : sum_out[3:0];

endmodule