module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum;
    wire       overflow;
    wire [4:0] corrected_sum;

    // Step 1: Binary addition of inputs
    assign raw_sum = A + B + Cin;

    // Step 2: Overflow detection using bits
    // Condition 1: If bit 4 (carry out of 4th bit) is 1, overflow
    // Condition 2: If bits [3:0] > 9; since max 4'b1001=9, 
    // sum[3] & (sum[2] | sum[1]) indicates >9 in BCD
    assign overflow = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Step 3: Add correction of 6 (0110) if overflow
    wire [4:0] sum_plus_6 = {1'b0, raw_sum[3:0]} + 5'd6;
    assign corrected_sum = overflow ? sum_plus_6 : raw_sum;

    // Step 4: Output assignment
    assign Sum  = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule