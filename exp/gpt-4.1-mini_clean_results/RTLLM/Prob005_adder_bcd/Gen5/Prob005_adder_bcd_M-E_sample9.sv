module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum;
    wire       carry4;          // Carry out from bit 3 addition
    wire       correction_needed;
    wire [4:0] corrected_sum;

    // First perform 4-bit addition with carry-in, producing 5-bit raw sum
    assign {carry4, raw_sum[3:0]} = A + B + Cin;
    assign raw_sum[4] = 1'b0; // Upper bit initialized zero for uniform width

    // Determine if correction is needed:
    // Correction is needed if:
    // 1) The carry out of bit 3 addition is 1 (meaning sum >= 16), or
    // 2) The sum[3:0] > 9 (i.e., sum is invalid BCD digit)
    // We implement sum[3:0] > 9 detection via logical expression:
    // If (sum[3] & (sum[2] | sum[1])) | (sum[3] & sum[0]) then sum > 9
    // Alternatively, sum>9 if (sum > 4'b1001)

    // sum > 9 detection using combinational logic
    wire sum_gt_9 = (raw_sum[3] & (raw_sum[2] | raw_sum[1])) | (raw_sum[3] & raw_sum[0]);

    assign correction_needed = carry4 | sum_gt_9;

    // Add 6 (binary 0110) for correction if needed
    assign corrected_sum = correction_needed ? (raw_sum + 5'd6) : raw_sum;

    // Outputs
    assign Sum  = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule