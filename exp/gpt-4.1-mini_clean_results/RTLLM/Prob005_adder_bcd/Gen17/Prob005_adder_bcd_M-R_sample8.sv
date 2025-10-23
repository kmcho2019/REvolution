module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] raw_sum;         // 5-bit sum including carry
    wire       need_correction; // Correction flag
    wire [4:0] correction;      // Correction value (0 or 6)

    // Step 1: Perform 4-bit addition plus carry-in
    assign raw_sum = A + B + Cin;

    // Step 2: Determine if correction is needed
    // Correction needed if raw_sum > 9
    assign need_correction = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Step 3: Select correction value: 6 if needed, else 0
    assign correction = need_correction ? 5'd6 : 5'd0;

    // Step 4: Add correction to raw sum
    wire [5:0] corrected_sum = raw_sum + correction;

    // Output assignments
    assign Sum  = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule