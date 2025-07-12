module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum = A + B + Cin;

    // Correction needed if raw_sum > 9:
    // Use optimized boolean logic for correction detection
    // correction_needed = raw_sum[4] OR (raw_sum[3] AND (raw_sum[2] OR raw_sum[1]))
    wire correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Prepare correction value (6 = 4'b0110)
    wire [3:0] correction_val = 4'b0110;

    // Add correction_val if correction_needed; else add zero
    wire [4:0] corrected_sum;
    wire       carry_correction;

    // Use a 4-bit adder for sum_low + (correction_needed ? 6 : 0)
    wire [3:0] sum_low = raw_sum[3:0];

    wire c0 = correction_needed & correction_val[0];
    wire c1 = correction_needed & correction_val[1];
    wire c2 = correction_needed & correction_val[2];
    wire c3 = correction_needed & correction_val[3];

    wire carry0, carry1, carry2, carry3;
    wire s0, s1, s2, s3;

    // Bit 0 addition
    assign {carry0, s0} = {1'b0, sum_low[0]} + {1'b0, c0};
    // Bit 1 addition
    assign {carry1, s1} = {carry0, sum_low[1]} + {1'b0, c1};
    // Bit 2 addition
    assign {carry2, s2} = {carry1, sum_low[2]} + {1'b0, c2};
    // Bit 3 addition
    assign {carry3, s3} = {carry2, sum_low[3]} + {1'b0, c3};

    assign corrected_sum = {carry3, s3, s2, s1, s0};

    // Final output selection based on correction_needed
    assign Sum  = correction_needed ? corrected_sum[3:0] : sum_low;
    // Cout is high if correction added a carry or raw_sum had carry out
    assign Cout = correction_needed ? corrected_sum[4] : raw_sum[4];

endmodule