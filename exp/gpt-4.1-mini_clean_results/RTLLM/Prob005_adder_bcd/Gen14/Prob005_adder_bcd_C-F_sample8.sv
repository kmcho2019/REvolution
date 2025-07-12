module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    // Initial 5-bit binary sum (A+B+Cin)
    wire [4:0] raw_sum = A + B + Cin;

    // Detect if correction needed: raw_sum > 9
    // Condition: correction_needed = MSB of raw_sum is 1 OR
    // bit3 is 1 AND (bit2 OR bit1 is 1)
    wire correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Extract lower 4 bits of raw sum
    wire [3:0] sum_low = raw_sum[3:0];

    // Add 6 (0110) if correction is needed, else sum_low unchanged
    // Implement the 4-bit addition sum_low + (correction_needed ? 6 : 0) with minimal logic

    // bit 0 addition: sum_low[0] + 0 + 0 = sum_low[0]
    wire sum0 = sum_low[0];
    wire carry0 = 1'b0;

    // bit 1 addition: sum_low[1] + 1 + carry0
    wire sum1 = sum_low[1] ^ 1'b1 ^ carry0;
    wire carry1 = (sum_low[1] & 1'b1) | ((sum_low[1] ^ 1'b1) & carry0);

    // bit 2 addition: sum_low[2] + 1 + carry1
    wire sum2 = sum_low[2] ^ 1'b1 ^ carry1;
    wire carry2 = (sum_low[2] & 1'b1) | ((sum_low[2] ^ 1'b1) & carry1);

    // bit 3 addition: sum_low[3] + 0 + carry2
    wire sum3 = sum_low[3] ^ 1'b0 ^ carry2;
    wire carry3 = (sum_low[3] & 1'b0) | ((sum_low[3] ^ 1'b0) & carry2);

    // Final corrected sum bits muxed based on correction_needed
    wire [3:0] corrected_sum = correction_needed ? {sum3, sum2, sum1, sum0} : sum_low;

    // Final carry out: carry from correction addition OR original carry out
    // If correction applied, carry3 is relevant; else raw_sum[4]
    wire final_carry_out = correction_needed ? carry3 | raw_sum[4] : raw_sum[4];

    assign Sum  = corrected_sum;
    assign Cout = final_carry_out;

endmodule