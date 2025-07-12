module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] raw_sum;       // 5-bit sum (A + B + Cin)
    wire       correction_needed;
    wire [4:0] corrected_sum; // 5-bit sum after adding 6 for correction

    // Step 1: Perform initial 5-bit addition
    assign raw_sum = {1'b0, A} + {1'b0, B} + Cin;

    // Step 2: Check if correction needed: if raw_sum > 9
    // Condition: correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]))
    assign correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Step 3: Add 6 (0110) if correction is needed
    // corrected_sum = raw_sum + 6 if correction_needed else raw_sum
    wire [4:0] sum_plus_6;
    assign sum_plus_6 = raw_sum + 5'd6;

    // Step 4: Select between raw_sum and sum_plus_6 based on correction_needed
    wire [4:0] final_sum;
    assign final_sum = correction_needed ? sum_plus_6 : raw_sum;

    // Step 5: Output corrected 4-bit sum and carry out
    assign Sum  = final_sum[3:0];
    assign Cout = final_sum[4];

endmodule