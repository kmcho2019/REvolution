module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] bin_sum;        // 5-bit binary sum of inputs and carry-in
    wire       invalid_bcd;    // flag indicating BCD correction needed
    wire [3:0] corrected_sum;

    // Binary addition: A + B + Cin
    assign bin_sum = {1'b0, A} + {1'b0, B} + Cin;

    // Invalid BCD if sum > 9 or carry out is set
    // Detect if (bin_sum[4] == 1) or (bin_sum[3] & (bin_sum[2] | bin_sum[1]))
    // This corresponds to sum > 9 check without numeric comparator
    assign invalid_bcd = bin_sum[4] | (bin_sum[3] & (bin_sum[2] | bin_sum[1]));

    // BCD correction:
    // If invalid_bcd, add 6 (0110) to lower 4 bits of bin_sum, otherwise pass bin_sum as is.
    // Instead of using adder, implement conditional bit adjustment:
    // sum + 6 = sum + 4 + 2
    // Use logic:
    // bit0_corrected = bin_sum[0];
    // bit1_corrected = bin_sum[1] ^ invalid_bcd;
    // bit2_corrected = bin_sum[2] ^ invalid_bcd;
    // bit3_corrected = bin_sum[3] | invalid_bcd;

    assign corrected_sum[0] = bin_sum[0];
    assign corrected_sum[1] = bin_sum[1] ^ invalid_bcd;
    assign corrected_sum[2] = bin_sum[2] ^ invalid_bcd;
    assign corrected_sum[3] = bin_sum[3] | invalid_bcd;

    assign Sum  = corrected_sum;
    assign Cout = invalid_bcd;

endmodule