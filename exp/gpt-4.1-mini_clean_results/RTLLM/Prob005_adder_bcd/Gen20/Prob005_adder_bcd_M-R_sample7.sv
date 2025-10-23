module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum;          // Sum of A, B, and Cin with carry bit
    wire       correction_needed;
    wire [3:0] correction;       // 4-bit correction value
    wire [4:0] corrected_sum;

    // Stage 1: Binary addition of inputs + carry-in
    assign raw_sum = {1'b0, A} + {1'b0, B} + Cin;

    // Determine if BCD correction is needed: sum > 9
    assign correction_needed = (raw_sum > 5'd9);

    // Correction value is 6 if needed, else 0
    assign correction = correction_needed ? 4'b0110 : 4'b0000;

    // Stage 2: Add correction to lower 4 bits of raw_sum plus carry from raw_sum[4]
    // Include raw_sum[4] (carry out from lower 4-bit addition) in the sum
    assign corrected_sum = {1'b0, raw_sum[3:0]} + {1'b0, correction};

    // Outputs
    assign Sum  = corrected_sum[3:0];
    assign Cout = correction_needed;

endmodule