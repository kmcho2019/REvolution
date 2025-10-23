module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    // Binary addition of inputs and carry-in
    wire [4:0] bin_sum = A + B + Cin;

    // Detect if correction is needed: sum > 9 means sum[4] == 1 or (sum[3] == 1 and (sum[2] == 1 or sum[1] == 1))
    wire invalid_bcd = bin_sum[4] | (bin_sum[3] & (bin_sum[2] | bin_sum[1]));

    // Correction value = 6 (0110) applied only when invalid_bcd is asserted
    // We add 6 to the lower 4 bits of bin_sum if invalid_bcd is high.
    wire [3:0] corrected_lower = bin_sum[3:0] + 4'b0110;

    // Final sum selection
    assign Sum = invalid_bcd ? corrected_lower : bin_sum[3:0];

    // Carry out is 1 if correction was needed
    assign Cout = invalid_bcd;

endmodule