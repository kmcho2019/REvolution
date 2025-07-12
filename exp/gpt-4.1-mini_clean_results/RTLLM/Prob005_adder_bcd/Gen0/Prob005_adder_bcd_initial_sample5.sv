module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] bin_sum;       // 5-bit to hold sum + carry
    wire [4:0] corrected_sum;
    wire       need_correction;

    // Binary addition of inputs and carry-in
    assign bin_sum = A + B + Cin;

    // Determine if correction is needed (sum > 9)
    assign need_correction = (bin_sum > 5'd9);

    // If correction needed, add 6 (0110) to bin_sum
    assign corrected_sum = need_correction ? (bin_sum + 5'd6) : bin_sum;

    // Output sum is the lower 4 bits of corrected sum
    assign Sum = corrected_sum[3:0];

    // Carry out is the MSB of corrected sum (bit 4)
    assign Cout = corrected_sum[4];

endmodule