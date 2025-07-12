module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    // Step 1: 5-bit raw sum of A, B, and Cin
    wire [4:0] raw_sum = {1'b0, A} + {1'b0, B} + Cin;

    // Step 2: Correction needed if raw_sum > 9
    // correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));
    wire correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Step 3: Conditionally add 6 (0110) if correction needed; else pass raw_sum[3:0]

    wire [3:0] sum_low = raw_sum[3:0];
    wire [3:0] correction = 4'b0110;

    // 4-bit adder to add correction value when needed
    wire c0 = 1'b0;
    wire c1, c2, c3, c4;

    wire s0 = sum_low[0] ^ (correction_needed & correction[0]) ^ c0;
    assign c1 = (sum_low[0] & (correction_needed & correction[0])) | (sum_low[0] & c0) | ((correction_needed & correction[0]) & c0);

    wire s1 = sum_low[1] ^ (correction_needed & correction[1]) ^ c1;
    assign c2 = (sum_low[1] & (correction_needed & correction[1])) | (sum_low[1] & c1) | ((correction_needed & correction[1]) & c1);

    wire s2 = sum_low[2] ^ (correction_needed & correction[2]) ^ c2;
    assign c3 = (sum_low[2] & (correction_needed & correction[2])) | (sum_low[2] & c2) | ((correction_needed & correction[2]) & c2);

    wire s3 = sum_low[3] ^ (correction_needed & correction[3]) ^ c3;
    assign c4 = (sum_low[3] & (correction_needed & correction[3])) | (sum_low[3] & c3) | ((correction_needed & correction[3]) & c3);

    // Step 4: Output assignments
    assign Sum  = correction_needed ? {s3, s2, s1, s0} : sum_low;

    // Carry-out is c4 if correction happened; else raw_sum[4]
    assign Cout = correction_needed ? c4 : raw_sum[4];

endmodule