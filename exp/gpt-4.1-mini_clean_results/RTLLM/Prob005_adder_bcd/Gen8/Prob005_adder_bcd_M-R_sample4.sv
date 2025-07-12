module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    // Perform initial 5-bit addition (includes carry-out)
    wire [4:0] raw_sum = A + B + Cin;

    // Correction needed if raw_sum > 9 (decimal 9)
    // Boolean condition: correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]))
    wire correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // BCD correction value 6 (binary 00110)
    localparam [4:0] BCD_CORRECTION = 5'b00110;

    // Conditionally add the correction (6) if needed
    wire [4:0] corrected_sum = correction_needed ? (raw_sum + BCD_CORRECTION) : raw_sum;

    // Output the lower 4 bits as Sum and the MSB as Cout
    assign Sum  = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule