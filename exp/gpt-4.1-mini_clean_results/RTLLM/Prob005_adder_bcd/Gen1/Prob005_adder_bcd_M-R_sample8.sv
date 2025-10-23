module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum;
    wire       carry_needed;
    wire [4:0] corrected_sum;

    // Compute raw sum of inputs plus carry-in
    assign raw_sum = A + B + Cin;

    // Determine if correction is needed: sum > 9 (1001)
    // Condition 1: raw_sum[4] == 1 (sum > 15)
    // Condition 2: raw_sum[3] & (raw_sum[2] | raw_sum[1]) indicates sum > 9
    assign carry_needed = (raw_sum > 5'd9);

    // Add correction of 6 if needed to bring result into valid BCD range
    assign corrected_sum = carry_needed ? (raw_sum + 5'd6) : raw_sum;

    // Output sum and carry-out
    assign Sum  = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule