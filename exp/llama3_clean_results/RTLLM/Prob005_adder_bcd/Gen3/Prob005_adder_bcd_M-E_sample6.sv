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

    // Check if the MSB of the binary sum is set (indicating sum > 9)
    wire msb_set;
    assign msb_set = bin_sum[4];

    // Apply correction if MSB is set
    wire [4:0] corrected_sum;
    assign corrected_sum = msb_set? (bin_sum + 6) : bin_sum;

    // Generate carry-out if MSB was set
    assign Cout = msb_set;

    // Assign the corrected sum to the output port, masking off the MSB
    assign Sum = corrected_sum[3:0];

endmodule