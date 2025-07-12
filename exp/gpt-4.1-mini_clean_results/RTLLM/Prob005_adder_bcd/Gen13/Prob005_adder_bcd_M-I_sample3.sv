module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] raw_sum;
    wire       correction_needed;

    // Step 1: 5-bit binary addition
    assign raw_sum = A + B + Cin;

    // Step 2: Optimized comparator for correction (sum > 9)
    // raw_sum > 9 if:
    // raw_sum[4] == 1 (sum >= 16) OR
    // (raw_sum[3] & (raw_sum[2] | raw_sum[1])) == 1
    assign correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Step 3: Corrected sum calculation - add 6 only when needed
    // Adding 6 (0110) to raw_sum[3:0] when correction_needed == 1
    wire c0, c1, c2;

    // Bit 0 addition: raw_sum[0] + 0 + 0 = raw_sum[0]
    wire sum0 = raw_sum[0];

    // Bit 1 addition: raw_sum[1] + 1 + 0 (when correction_needed)
    // half adder: sum_bit1 and carry c0
    wire sum1 = raw_sum[1] ^ correction_needed;
    assign c0  = raw_sum[1] & correction_needed;

    // Bit 2 addition: raw_sum[2] + 1 + c0
    wire sum2 = raw_sum[2] ^ correction_needed ^ c0;
    assign c1  = (raw_sum[2] & correction_needed) | (raw_sum[2] & c0) | (correction_needed & c0);

    // Bit 3 addition: raw_sum[3] + 0 + c1
    wire sum3 = raw_sum[3] ^ c1;
    assign c2  = raw_sum[3] & c1;

    assign Sum  = {sum3, sum2, sum1, sum0};
    assign Cout = correction_needed;

endmodule