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

    // Step 1: Binary addition of inputs and carry-in
    assign raw_sum = {1'b0, A} + {1'b0, B} + Cin;

    // Step 2: Detect if correction is needed:
    // Condition 1: raw_sum > 9 (4'b1001), i.e. raw_sum[4] == 1 or raw_sum[3:0] > 9
    // We can check: if raw_sum[4] is 1 or raw_sum[3:0] > 9 => correction needed
    assign correction_needed = (raw_sum > 5'd9);

    // Step 3: If correction needed, add 6 (5'b00110) to raw_sum
    // Use a 5-bit adder for the correction addition, controlled by correction_needed
    assign corrected_sum = raw_sum + (correction_needed ? 5'd6 : 5'd0);

    // Outputs
    assign Sum  = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule