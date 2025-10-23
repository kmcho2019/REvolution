module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] raw_sum;       // 5-bit sum: 4 bits + carry-out
    wire       carry_raw;     // carry out from raw addition

    // Step 1: Raw binary addition (4 bits + Cin)
    assign raw_sum = {1'b0, A} + {1'b0, B} + Cin;
    assign carry_raw = raw_sum[4];

    // Step 2: Detect if correction is needed
    // Correction needed if raw sum > 9 OR carry_out from addition
    // raw_sum[3:0] > 9 --> can be detected as (raw_sum[3] & (raw_sum[2] | raw_sum[1])) or raw_sum >= 10
    wire correction_needed;
    assign correction_needed = carry_raw | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Step 3: Add correction (6) if needed
    wire [4:0] corrected_sum;
    wire       c_correction;

    assign {c_correction, corrected_sum[3:0]} = raw_sum[3:0] + (correction_needed ? 4'd6 : 4'd0);

    // Step 4: Compute final carry out: either original carry or carry from correction addition
    assign Cout = correction_needed ? c_correction : carry_raw;

    // Step 5: Assign final BCD sum output
    assign Sum = corrected_sum[3:0];

endmodule