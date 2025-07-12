module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] bin_sum;
    wire       need_correction;
    wire [4:0] corrected_sum;

    // Binary addition of inputs and carry-in
    assign bin_sum = A + B + Cin;

    // Correction needed if sum > 9
    // sum > 9 if (bin_sum[4] == 1) OR (bin_sum[3] & (bin_sum[2] | bin_sum[1]))
    assign need_correction = bin_sum[4] | (bin_sum[3] & (bin_sum[2] | bin_sum[1]));

    // Add 6 if correction is needed, else keep sum as is
    assign corrected_sum = need_correction ? (bin_sum + 5'd6) : bin_sum;

    // Output the 4-bit BCD sum
    assign Sum = corrected_sum[3:0];

    // Carry out is the MSB of corrected sum
    assign Cout = corrected_sum[4];

endmodule