module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    // Step 1: Raw 5-bit addition of inputs
    wire [4:0] raw_sum = {1'b0, A} + {1'b0, B} + Cin;

    // Step 2: Correction detection: sum > 9
    wire correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Step 3: Corrected sum calculation without a second adder
    // If correction_needed, add 6 (0110) to raw_sum[3:0], carry propagate manually

    wire [3:0] raw_sum_4bits = raw_sum[3:0];
    wire [3:0] corrected_sum;
    wire carry_from_correction;

    // Manual 4-bit addition of raw_sum_4bits + 6 when correction_needed
    // Use simple gate-level addition for adding 6 (0110) only if correction_needed

    wire [3:0] add_val = correction_needed ? 4'b0110 : 4'b0000;

    // Implement 4-bit adder for raw_sum_4bits + add_val
    wire c0, c1, c2, c3;

    // Bit 0
    assign {c0, corrected_sum[0]} = raw_sum_4bits[0] + add_val[0];

    // Bit 1
    assign {c1, corrected_sum[1]} = raw_sum_4bits[1] + add_val[1] + c0;

    // Bit 2
    assign {c2, corrected_sum[2]} = raw_sum_4bits[2] + add_val[2] + c1;

    // Bit 3
    assign {c3, corrected_sum[3]} = raw_sum_4bits[3] + add_val[3] + c2;

    // Step 4: Carry out is the OR of raw_sum[4] or the carry out from corrected sum addition (c3)
    // raw_sum[4] indicates carry out from initial sum of A+B+Cin
    // c3 indicates carry out from correction addition stage

    // The final carry out can be just c3 because if correction_needed is 0, add_val=0 and c3=0;
    // However, to be safe, we include raw_sum[4] in carry_out.

    assign Cout = raw_sum[4] | c3;
    assign Sum = corrected_sum;

endmodule