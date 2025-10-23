module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    // Step 1: Initial 5-bit binary addition of A, B, and Cin
    wire [4:0] raw_sum = {1'b0, A} + {1'b0, B} + Cin;

    // Step 2: Determine if correction is needed:
    // correction needed if raw_sum > 9
    // Using boolean logic:
    // raw_sum > 9 if MSB is 1 (raw_sum[4]) or
    // raw_sum[3] == 1 and (raw_sum[2] == 1 or raw_sum[1] == 1)
    wire correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Step 3: Prepare correction value (5 bits), 6 = 00110
    wire [4:0] correction = correction_needed ? 5'b00110 : 5'b00000;

    // Step 4: Add correction to raw_sum
    wire [4:0] corrected_sum = raw_sum + correction;

    // Step 5: Assign outputs
    assign Sum  = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule