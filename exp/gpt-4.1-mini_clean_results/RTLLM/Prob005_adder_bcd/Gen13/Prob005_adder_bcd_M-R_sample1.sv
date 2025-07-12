module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    // Step 1: Initial 5-bit addition
    wire [4:0] raw_sum;
    assign raw_sum = {1'b0, A} + {1'b0, B} + Cin;

    // Step 2: Correction detection logic (sum > 9)
    wire correction_needed;
    assign correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Step 3: Assign correction value based on correction_needed
    wire [4:0] correction_value;
    assign correction_value = correction_needed ? 5'd6 : 5'd0;

    // Step 4: Compute corrected sum
    wire [4:0] corrected_sum;
    assign corrected_sum = raw_sum + correction_value;

    // Step 5: Outputs
    assign Sum  = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule