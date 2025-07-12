module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum;
    wire       correction_needed;
    wire [4:0] corrected_sum;

    // Binary addition of inputs plus carry-in
    assign raw_sum = A + B + Cin;

    // Correction needed if sum > 9:
    // correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]))
    assign correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Adding 6 (0110) when correction is needed.
    // Instead of full 5-bit add, perform correction as:
    // corrected_sum = raw_sum + 6 if correction_needed else raw_sum
    // Implement addition of 6 in bits:
    // bit0 corrected = raw_sum[0]
    // bit1 corrected = raw_sum[1] ^ correction_needed
    // bit2 corrected = raw_sum[2] ^ correction_needed
    // bit3 corrected = raw_sum[3] & ~correction_needed | ~raw_sum[3] & (raw_sum[2] & correction_needed)
    // bit4 corrected = raw_sum[4] | (raw_sum[3] & raw_sum[2] & correction_needed)
    // But simpler to do full add of 6 conditionally since logic is small:
    assign corrected_sum = correction_needed ? (raw_sum + 5'd6) : raw_sum;

    assign Sum  = corrected_sum[3:0];
    assign Cout = correction_needed;

endmodule