module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    // First: 4-bit binary addition with carry out
    wire [4:0] bin_sum = {1'b0, A} + {1'b0, B} + Cin;

    // Extract intermediate sum bits
    wire c3 = bin_sum[3];        // carry into bit 3
    wire c4 = bin_sum[4];        // carry out (bit 4)

    // Correction is needed if sum > 9 or carry out from bit 3 is set (complex condition)
    wire need_correction = (c4) | ( (bin_sum[3] & (bin_sum[2] | bin_sum[1])) );

    // Add correction of 6 if needed
    wire [4:0] corrected_sum = bin_sum + (need_correction ? 5'd6 : 5'd0);

    assign Sum = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule