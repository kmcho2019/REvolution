module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum;
    wire       correction_needed;

    // 5-bit binary addition of inputs plus carry-in
    assign raw_sum = A + B + Cin;

    // Correction needed if raw_sum > 9
    // raw_sum > 9 if:
    // - raw_sum[4] == 1 (sum >= 16)
    // OR
    // - raw_sum[4] == 0 and raw_sum[3] & (raw_sum[2] | raw_sum[1]) is 1
    // (binary sum > 9 is when MSB nibble > 1001)
    assign correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Adding 6 (0110) if correction_needed else 0
    // Implement addition by bits, minimizing logic:
    wire [3:0] add6 = 4'b0110;

    // When correction is needed, add 6 to lower 4 bits of raw_sum
    wire [4:0] corrected_sum = {1'b0, raw_sum[3:0]} + (correction_needed ? {1'b0, add6} : 5'b0);

    // Final outputs
    assign Sum  = corrected_sum[3:0];
    assign Cout = correction_needed;

endmodule