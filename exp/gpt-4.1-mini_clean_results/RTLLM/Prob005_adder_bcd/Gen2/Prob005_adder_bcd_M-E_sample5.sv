module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum;
    wire       correction_needed;

    // 4-bit addition with carry-out
    assign raw_sum = {1'b0, A} + {1'b0, B} + Cin;

    // Determine if correction is needed:
    // correction if sum > 9 or if carry-out (raw_sum[4]) is set
    assign correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Perform BCD correction by adding 6 if needed
    // Instead of using a second adder, use combinational logic:
    // sum_corrected = raw_sum + (correction_needed ? 6 : 0);
    wire [3:0] corrected_sum;
    wire       cout_internal;

    // Add 6 conditionally using logic:
    // Adding 6 (0110) can be done by XOR and AND gates for lower bits,
    // but here we implement it straightforwardly as a small combinational adder:

    // Low 4 bits of raw_sum
    wire [3:0] s = raw_sum[3:0];
    wire [4:0] correction_value = correction_needed ? 5'd6 : 5'd0;

    // 4-bit addition for correction
    wire [4:0] corrected_full_sum = raw_sum + correction_value;

    assign corrected_sum = corrected_full_sum[3:0];
    assign Cout = corrected_full_sum[4];

    assign Sum = corrected_sum;

endmodule