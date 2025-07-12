module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum;
    wire       correction;

    // Perform initial 4-bit addition with carry
    assign raw_sum = A + B + Cin;

    // Check if correction is needed (sum > 9 or carry out)
    assign correction = (raw_sum > 5'd9);

    // Add 6 if correction needed for BCD adjustment
    wire [4:0] corrected_sum = raw_sum + (correction ? 5'd6 : 5'd0);

    assign Sum  = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule