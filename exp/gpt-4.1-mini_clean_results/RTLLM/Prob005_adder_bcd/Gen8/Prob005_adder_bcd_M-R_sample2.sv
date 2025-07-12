module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum;
    wire       correction_needed;
    wire [4:0] corrected_sum;

    // Step 1: Compute 5-bit binary sum of inputs
    assign raw_sum = A + B + Cin;

    // Step 2: Determine if correction needed (sum > 9)
    assign correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Step 3: Add 6 to lower nibble if correction_needed
    // Use direct '+' operator to add 6 (decimal) when needed
    assign corrected_sum = raw_sum + (correction_needed ? 5'd6 : 5'd0);

    // Step 4: Select the corrected or uncorrected 4-bit sum output
    assign Sum  = corrected_sum[3:0];

    // Step 5: Carry out indicates sum exceeded 9 before or after correction
    assign Cout = correction_needed;

endmodule