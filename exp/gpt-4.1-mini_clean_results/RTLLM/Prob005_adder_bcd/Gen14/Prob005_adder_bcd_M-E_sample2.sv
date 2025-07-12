module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] raw_sum;         // 5-bit sum to hold carry out
    wire       correction_needed;
    wire [3:0] corrected_sum;
    
    // Step 1: Perform 5-bit addition
    assign raw_sum = {1'b0, A} + {1'b0, B} + Cin;

    // Step 2: Determine if correction is needed.
    // Correction needed if raw_sum > 9
    // raw_sum > 9 if raw_sum[4] == 1 (carry from 4-bit addition)
    // or (raw_sum[3:0] > 9)
    // Condition: correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]))
    assign correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Step 3: Instead of adding 6, subtract 10 (1010 binary) when correction needed:
    // corrected_sum = raw_sum - 10 if correction_needed else raw_sum
    // subtraction by 10 = subtraction by 8 + 2
    // Implemented by simple combinational logic using borrow logic.
    // Since raw_sum is 5-bit and sum is 4-bit, we only do 4-bit subtraction ignoring MSB

    wire [3:0] raw_sum_low = raw_sum[3:0];

    // Subtract 10 (1010) when correction_needed
    // We'll do: corrected_sum = correction_needed ? raw_sum_low - 4'd10 : raw_sum_low

    // Simple combinational subtractor for raw_sum_low - 10

    wire b3 = 1'b1, b2 = 0, b1 = 1'b1, b0 = 0; // 10 in binary = 1010

    wire b_sub0, b_sub1, b_sub2, b_sub3;
    wire diff0, diff1, diff2, diff3;
    wire borrow0, borrow1, borrow2, borrow3;

    // bit0
    assign borrow0 = (~raw_sum_low[0]) & b0;
    assign diff0 = raw_sum_low[0] ^ b0;

    // bit1
    assign borrow1 = ((~raw_sum_low[1]) & b1) | ((~raw_sum_low[1]) & borrow0) | (b1 & borrow0);
    assign diff1 = raw_sum_low[1] ^ b1 ^ borrow0;

    // bit2
    assign borrow2 = ((~raw_sum_low[2]) & b2) | ((~raw_sum_low[2]) & borrow1) | (b2 & borrow1);
    assign diff2 = raw_sum_low[2] ^ b2 ^ borrow1;

    // bit3
    assign borrow3 = ((~raw_sum_low[3]) & b3) | ((~raw_sum_low[3]) & borrow2) | (b3 & borrow2);
    assign diff3 = raw_sum_low[3] ^ b3 ^ borrow2;

    wire [3:0] subtracted = {diff3, diff2, diff1, diff0};

    // Step 4: Final Sum selection
    assign Sum = correction_needed ? subtracted : raw_sum_low;

    // Step 5: Carry-out generated if correction is needed
    assign Cout = correction_needed;

endmodule