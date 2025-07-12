module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum;

    // Step 1: Perform 4-bit binary addition with carry-in, 5-bit result
    assign raw_sum = {1'b0, A} + {1'b0, B} + Cin;

    // Step 2: Determine if correction is needed (sum > 9)
    wire correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Step 3: Add 6 (0110) if correction is needed
    // We'll manually add 6 to raw_sum[3:0], carry into raw_sum[4]
    wire c0, c1, c2, c3; // carries for each bit addition

    // bit0 addition: raw_sum[0] + 0 + 0 (6 LSB is 0)
    assign c0 = 0; // no carry from bit0 since adding 0

    // bit1 addition: raw_sum[1] + 1 + carry from bit0
    assign {c1, Sum[1]} = raw_sum[1] + 1'b1 + c0;

    // bit2 addition: raw_sum[2] + 1 + carry from bit1
    assign {c2, Sum[2]} = raw_sum[2] + 1'b1 + c1;

    // bit3 addition: raw_sum[3] + 0 + carry from bit2
    assign {c3, Sum[3]} = raw_sum[3] + 1'b0 + c2;

    // bit0 of sum (lowest bit) is unchanged if correction needed else raw_sum[0]
    // correction adds 6 (0110) so bit0 is added with 0, so raw_sum[0] stays same
    wire [3:0] sum_with_correction = {Sum[3], Sum[2], Sum[1], raw_sum[0]};

    // If no correction needed, Sum = raw_sum[3:0], else sum_with_correction
    assign Sum = correction_needed ? sum_with_correction : raw_sum[3:0];

    // Final carry out is:
    // if correction needed, carry out is raw_sum[4] + carry from bit3 addition (c3)
    // but raw_sum[4] and c3 are both 1-bit signals; their sum may be up to 2
    // So Cout = correction_needed ? (raw_sum[4] | c3) : raw_sum[4]
    assign Cout = correction_needed ? (raw_sum[4] | c3) : raw_sum[4];

endmodule